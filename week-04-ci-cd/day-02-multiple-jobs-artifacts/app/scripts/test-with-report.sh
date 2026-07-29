#!/usr/bin/env bash

set -euo pipefail

REPORT_FILE="${TEST_REPORT_FILE:-reports/test-report.txt}"
REPORT_DIRECTORY="$(dirname "$REPORT_FILE")"

mkdir -p "$REPORT_DIRECTORY"

echo "Node.js Test Report"
echo "==================="
echo ""
echo "Node version: $(node --version)"
echo "Report file: $REPORT_FILE"
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
echo "Test exit code: $TEST_EXIT_CODE"
echo "Report saved to: $REPORT_FILE"

exit "$TEST_EXIT_CODE"