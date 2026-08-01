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

echo "Week 05 Day 01 - Local Validation"
echo "================================="
echo ""

echo "1. Validating shell syntax"

while IFS= read -r -d '' SCRIPT_FILE; do
  echo "Checking: $SCRIPT_FILE"
  bash -n "$SCRIPT_FILE"
done < <(
  find "$PROJECT_DIRECTORY/scripts" \
    -type f \
    -name '*.sh' \
    -print0
)

echo ""
echo "2. Checking executable permissions"

while IFS= read -r -d '' SCRIPT_FILE; do
  if [ ! -x "$SCRIPT_FILE" ]; then
    echo "Script is not executable:"
    echo "$SCRIPT_FILE"
    exit 1
  fi
done < <(
  find "$PROJECT_DIRECTORY/scripts" \
    -type f \
    -name '*.sh' \
    -print0
)

echo "All shell scripts are executable."

echo ""
echo "3. Checking for tracked local configuration"

if git \
  -C "$REPOSITORY_ROOT" \
  ls-files \
  --error-unmatch \
  "$PROJECT_DIRECTORY/config/lab.env" \
  >/dev/null 2>&1; then

  echo "config/lab.env must not be tracked."
  exit 1
fi

echo "Local configuration is not tracked."

echo ""
echo "4. Checking for tracked reports"

TRACKED_REPORTS="$(
  git \
    -C "$REPOSITORY_ROOT" \
    ls-files \
    "$PROJECT_DIRECTORY/reports"
)"

if [ -n "$TRACKED_REPORTS" ]; then
  echo "Generated reports must not be tracked:"
  echo "$TRACKED_REPORTS"
  exit 1
fi

echo "Generated reports are not tracked."

echo ""
echo "5. Checking repository for credentials"

SECRET_PATTERN='AKIA[0-9A-Z]{16}|ASIA[0-9A-Z]{16}|-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----'

set +e

git \
  -C "$REPOSITORY_ROOT" \
  grep \
  --line-number \
  --extended-regexp \
  "$SECRET_PATTERN" \
  -- .

SECRET_RESULT=$?

set -e

if [ "$SECRET_RESULT" -eq 0 ]; then
  echo "Possible credential material was found."
  exit 1
fi

echo "No credential patterns were found."

echo ""
echo "Local validation completed successfully."