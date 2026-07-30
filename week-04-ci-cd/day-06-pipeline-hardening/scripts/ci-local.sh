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

APP_DIRECTORY="$PROJECT_DIRECTORY/app"

echo "Week 04 Day 06 - Local Hardened CI"
echo "================================="
echo ""

echo "1. Application dependency installation"

cd "$APP_DIRECTORY"

npm ci --ignore-scripts

echo ""
echo "2. JavaScript syntax validation"

npm run lint

echo ""
echo "3. Automated tests"

npm test

echo ""
echo "4. Application execution"

npm start

echo ""
echo "5. GitHub Action pin validation"

cd "$PROJECT_DIRECTORY"

python3 scripts/check-action-pins.py

echo ""
echo "6. Rejecting pull_request_target workflows"

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
echo "7. GitHub Actions workflow validation"

docker run \
  --rm \
  --volume "$REPOSITORY_ROOT:/repo" \
  --workdir /repo \
  rhysd/actionlint:1.7.12

echo ""
echo "Local hardened CI completed successfully."
