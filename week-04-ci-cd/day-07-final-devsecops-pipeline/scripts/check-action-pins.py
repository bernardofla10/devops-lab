#!/usr/bin/env python3

from __future__ import annotations

import re
from pathlib import Path


SCRIPT_PATH = Path(__file__).resolve()
REPOSITORY_ROOT = SCRIPT_PATH.parents[3]
WORKFLOW_DIRECTORY = REPOSITORY_ROOT / ".github" / "workflows"

USES_PATTERN = re.compile(
    r"^\s*(?:-\s+)?uses:\s+"
    r"(?P<value>[^\s#]+)",
    re.MULTILINE,
)

FULL_SHA_PATTERN = re.compile(r"^[0-9a-f]{40}$")


def main() -> int:
    workflow_files = sorted(
        [
            *WORKFLOW_DIRECTORY.glob("*.yml"),
            *WORKFLOW_DIRECTORY.glob("*.yaml"),
        ]
    )

    violations: list[str] = []

    for workflow_file in workflow_files:
        content = workflow_file.read_text(
            encoding="utf-8"
        )

        for match in USES_PATTERN.finditer(content):
            value = match.group("value")

            if value.startswith("./"):
                continue

            if value.startswith("docker://"):
                continue

            if "@" not in value:
                violations.append(
                    f"{workflow_file}: action without reference: "
                    f"{value}"
                )

                continue

            _, reference = value.rsplit("@", maxsplit=1)

            if not FULL_SHA_PATTERN.fullmatch(reference):
                line_number = (
                    content.count(
                        "\n",
                        0,
                        match.start(),
                    )
                    + 1
                )

                violations.append(
                    f"{workflow_file.relative_to(REPOSITORY_ROOT)}:"
                    f"{line_number}: {value}"
                )

    if violations:
        print("Unpinned GitHub Actions were found:\n")

        for violation in violations:
            print(f"- {violation}")

        print(
            "\nEvery external action must use "
            "a full 40-character commit SHA."
        )

        return 1

    print(
        "All external GitHub Actions are pinned "
        "to full commit SHAs."
    )

    return 0


if __name__ == "__main__":
    raise SystemExit(main())