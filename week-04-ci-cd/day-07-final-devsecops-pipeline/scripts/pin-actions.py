#!/usr/bin/env python3

# o script faz:
# encontra uses:
# extrai owner/repository/ref
# consulta a API do GitHub
# resolve o commit atual da tag
# substitui pela SHA completa
# preserva a tag como comentário

from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path


SCRIPT_PATH = Path(__file__).resolve()
REPOSITORY_ROOT = SCRIPT_PATH.parents[3]
WORKFLOW_DIRECTORY = REPOSITORY_ROOT / ".github" / "workflows"

ACTION_PATTERN = re.compile(
    r"^(?P<prefix>\s*(?:-\s+)?uses:\s+)"
    r"(?P<action>"
    r"(?P<owner>[A-Za-z0-9_.-]+)/"
    r"(?P<repository>[A-Za-z0-9_.-]+)"
    r"(?P<subpath>(?:/[A-Za-z0-9_.-]+)*)"
    r")@"
    r"(?P<reference>[^\s#]+)"
    r"(?P<comment>\s*(?:#.*)?)$",
    re.MULTILINE,
)

FULL_SHA_PATTERN = re.compile(r"^[0-9a-f]{40}$")
VERSION_COMMENT_PATTERN = re.compile(
    r"#\s*(?P<reference>[A-Za-z0-9._/-]+)\s*$"
)


def run_command(arguments: list[str]) -> str:
    try:
        result = subprocess.run(
            arguments,
            check=True,
            text=True,
            capture_output=True,
        )
    except subprocess.CalledProcessError as error:
        print(error.stdout, file=sys.stderr)
        print(error.stderr, file=sys.stderr)
        raise

    return result.stdout.strip()


def resolve_commit(repository: str, reference: str) -> str:
    print(f"Resolving {repository}@{reference}...")

    sha = run_command(
        [
            "gh",
            "api",
            f"repos/{repository}/commits/{reference}",
            "--jq",
            ".sha",
        ]
    )

    if not FULL_SHA_PATTERN.fullmatch(sha):
        raise RuntimeError(
            f"GitHub returned an invalid SHA for "
            f"{repository}@{reference}: {sha}"
        )

    return sha


def update_workflow(workflow_file: Path) -> bool:
    original_content = workflow_file.read_text(
        encoding="utf-8"
    )

    cache: dict[tuple[str, str], str] = {}

    def replace_action(match: re.Match[str]) -> str:
        owner = match.group("owner")
        repository_name = match.group("repository")
        repository = f"{owner}/{repository_name}"

        action = match.group("action")
        current_reference = match.group("reference")
        comment = match.group("comment").strip()

        requested_reference = current_reference

        if FULL_SHA_PATTERN.fullmatch(current_reference):
            comment_match = VERSION_COMMENT_PATTERN.search(comment)

            if not comment_match:
                return match.group(0)

            requested_reference = comment_match.group("reference")

        key = (repository, requested_reference)

        if key not in cache:
            cache[key] = resolve_commit(
                repository,
                requested_reference,
            )

        sha = cache[key]

        return (
            f"{match.group('prefix')}"
            f"{action}@{sha} "
            f"# {requested_reference}"
        )

    updated_content = ACTION_PATTERN.sub(
        replace_action,
        original_content,
    )

    if updated_content == original_content:
        return False

    workflow_file.write_text(
        updated_content,
        encoding="utf-8",
    )

    return True


def main() -> int:
    if not WORKFLOW_DIRECTORY.exists():
        print(
            f"Workflow directory not found: "
            f"{WORKFLOW_DIRECTORY}",
            file=sys.stderr,
        )

        return 1

    try:
        run_command(["gh", "auth", "status"])
    except subprocess.CalledProcessError:
        print(
            "GitHub CLI is not authenticated. "
            "Run: gh auth login",
            file=sys.stderr,
        )

        return 1

    workflow_files = sorted(
        [
            *WORKFLOW_DIRECTORY.glob("*.yml"),
            *WORKFLOW_DIRECTORY.glob("*.yaml"),
        ]
    )

    if not workflow_files:
        print("No workflow files found.")
        return 1

    changed_files: list[Path] = []

    for workflow_file in workflow_files:
        print(f"\nProcessing {workflow_file.relative_to(REPOSITORY_ROOT)}")

        if update_workflow(workflow_file):
            changed_files.append(workflow_file)

    print("\nAction pinning completed.")

    if not changed_files:
        print("No files required updates.")
        return 0

    print("\nUpdated workflows:")

    for changed_file in changed_files:
        print(
            changed_file.relative_to(REPOSITORY_ROOT)
        )

    return 0


if __name__ == "__main__":
    raise SystemExit(main())