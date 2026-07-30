#!/usr/bin/env bash

set -euo pipefail

REPOSITORY_ROOT="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../../.." &&
  pwd
)"

CODEOWNERS_FILE="$REPOSITORY_ROOT/.github/CODEOWNERS"

echo "CODEOWNERS Generator"
echo "===================="
echo ""

if ! command -v gh >/dev/null 2>&1; then
  echo "GitHub CLI was not found."
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "GitHub CLI is not authenticated."
  echo "Run: gh auth login"
  exit 1
fi

GITHUB_USERNAME="$(
  gh api user \
    --jq '.login'
)"

if [ -z "$GITHUB_USERNAME" ]; then
  echo "Could not determine GitHub username."
  exit 1
fi

cat > "$CODEOWNERS_FILE" <<EOF
# Default repository owner
* @$GITHUB_USERNAME

# CI/CD and repository governance
/.github/workflows/ @$GITHUB_USERNAME
/.github/dependabot.yml @$GITHUB_USERNAME
/.github/dependency-review-config.yml @$GITHUB_USERNAME
/.github/CODEOWNERS @$GITHUB_USERNAME
/.github/pull_request_template.md @$GITHUB_USERNAME

# Week 04 pipeline hardening lab
/week-04-ci-cd/day-06-pipeline-hardening/ @$GITHUB_USERNAME
EOF

echo "CODEOWNERS generated:"
echo "$CODEOWNERS_FILE"
echo ""

cat "$CODEOWNERS_FILE"