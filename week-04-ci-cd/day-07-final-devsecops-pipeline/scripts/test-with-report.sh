#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

APP_DIRECTORY="$PROJECT_DIRECTORY/app"
REPORT_DIRECTORY="$PROJECT_DIRECTORY/reports/tests"
REPORT_FILE="$REPORT_DIRECTORY/node-tests.txt"

mkdir -p "$REPORT_DIRECTORY"

cd "$APP_DIRECTORY"

echo "Node.js Automated Test Report"
echo "============================="
echo ""
echo "Node: $(node --version)"
echo "npm:  $(npm --version)"
echo ""

set +e

node \
  --test \
  --test-reporter=spec \
  2>&1 |
  tee "$REPORT_FILE"

TEST_EXIT_CODE="${PIPESTATUS[0]}"

set -e

{
  echo ""
  echo "Node version: $(node --version)"
  echo "Exit code: $TEST_EXIT_CODE"
} >> "$REPORT_FILE"

echo ""
echo "Test report:"
echo "$REPORT_FILE"

exit "$TEST_EXIT_CODE"