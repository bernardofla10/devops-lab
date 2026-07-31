#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

REPOSITORY_ROOT="$(
  cd "$PROJECT_DIRECTORY/../.." &&
  pwd
)"

echo "GitHub Actions Security Checks"
echo "=============================="
echo ""

echo "1. Checking full-SHA action pins"

python3 \
  "$PROJECT_DIRECTORY/scripts/check-action-pins.py"

echo ""
echo "2. Rejecting pull_request_target"

if grep \
  --recursive \
  --line-number \
  --extended-regexp \
  '^[[:space:]]*pull_request_target[[:space:]]*:' \
  "$REPOSITORY_ROOT/.github/workflows"; then

  echo "pull_request_target is not allowed."
  exit 1
fi

echo "No pull_request_target workflows found."

echo ""
echo "3. Validating workflows with actionlint"

docker run \
  --rm \
  --volume "$REPOSITORY_ROOT:/repo" \
  --workdir /repo \
  rhysd/actionlint:1.7.12

echo ""
echo "Workflow security checks passed."
