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

echo "Week 05 Day 02 - Local Validation"
echo "================================="
echo ""

echo "1. Validating shell syntax"

while IFS= read -r -d '' SCRIPT_FILE; do
  echo "Checking: $SCRIPT_FILE"
  bash -n "$SCRIPT_FILE"
done < <(
  find "$PROJECT_DIRECTORY" \
    -type f \
    -name '*.sh' \
    -print0
)

echo ""
echo "2. Checking executable permissions"

while IFS= read -r -d '' SCRIPT_FILE; do
  if [ ! -x "$SCRIPT_FILE" ]; then
    echo "File is not executable:"
    echo "$SCRIPT_FILE"
    exit 1
  fi
done < <(
  find "$PROJECT_DIRECTORY/scripts" \
    "$PROJECT_DIRECTORY/user-data" \
    -type f \
    -name '*.sh' \
    -print0
)

echo "Shell permissions are correct."

echo ""
echo "3. Validating JSON files"

while IFS= read -r -d '' JSON_FILE; do
  echo "Checking: $JSON_FILE"

  jq empty "$JSON_FILE"
done < <(
  find "$PROJECT_DIRECTORY/iam" \
    -type f \
    -name '*.json' \
    -print0
)

echo ""
echo "4. Checking local files are ignored"

for LOCAL_PATH in \
  "$PROJECT_DIRECTORY/config/lab.env" \
  "$PROJECT_DIRECTORY/state/resources.env" \
  "$PROJECT_DIRECTORY/reports/example.json"; do

  if git \
    -C "$REPOSITORY_ROOT" \
    check-ignore \
    -q \
    "$LOCAL_PATH"; then

    echo "Ignored: $LOCAL_PATH"
  else
    echo "Not ignored: $LOCAL_PATH"
    exit 1
  fi
done

echo ""
echo "5. Searching for credential patterns"

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