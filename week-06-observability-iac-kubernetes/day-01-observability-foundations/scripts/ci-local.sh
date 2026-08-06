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

WORKFLOW_FILE="$REPOSITORY_ROOT/.github/workflows/week-06-day-01-observability.yml"

echo "Week 06 Day 01 - Local CI"
echo "========================="
echo ""

echo "1. Shell syntax"

while IFS= read -r -d '' SCRIPT_FILE; do
  echo "Checking: $SCRIPT_FILE"
  bash -n "$SCRIPT_FILE"
done < <(
  find \
    "$PROJECT_DIRECTORY/scripts" \
    -type f \
    -name '*.sh' \
    -print0
)

echo ""
echo "2. Executable permissions"

while IFS= read -r -d '' SCRIPT_FILE; do
  if [ ! -x "$SCRIPT_FILE" ]; then
    echo "Not executable:"
    echo "$SCRIPT_FILE"
    exit 1
  fi
done < <(
  find \
    "$PROJECT_DIRECTORY/scripts" \
    -type f \
    \( -name '*.sh' -o -name '*.py' \) \
    -print0
)

echo ""
echo "3. Application checks"

"$PROJECT_DIRECTORY/scripts/app-checks.sh"

echo ""
echo "4. Docker Compose configuration"

docker compose \
  --file "$PROJECT_DIRECTORY/compose.yml" \
  config \
  >/dev/null

echo "Compose configuration is valid."

echo ""
echo "5. Dockerfile build check"

docker buildx build \
  --check \
  "$PROJECT_DIRECTORY"

echo ""
echo "6. Action pins"

python3 \
  "$PROJECT_DIRECTORY/scripts/check-action-pins.py"

echo ""
echo "7. Workflow syntax"

docker run \
  --rm \
  --volume "$REPOSITORY_ROOT:/repo" \
  --workdir /repo \
  rhysd/actionlint:1.7.12 \
  "$WORKFLOW_FILE"

echo ""
echo "8. Generated reports"

if git \
  -C "$REPOSITORY_ROOT" \
  ls-files \
  "$PROJECT_DIRECTORY/reports" |
  grep \
    --quiet .; then

  echo "Generated reports must not be tracked."
  exit 1
fi

echo "Generated reports are not tracked."

echo ""
echo "9. Credential patterns"

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
echo "Local CI passed."