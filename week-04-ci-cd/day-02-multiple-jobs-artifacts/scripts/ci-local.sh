#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

APP_DIRECTORY="$PROJECT_DIRECTORY/app"

cd "$APP_DIRECTORY"

echo "Week 04 Day 02 - Local Multi-job CI"
echo "==================================="
echo ""

echo "1. Cleaning generated files"
rm -rf reports dist
echo ""

echo "2. Environment"
echo "Node: $(node --version)"
echo "npm:  $(npm --version)"
echo ""

echo "3. Clean dependency installation"
npm ci
echo ""

echo "4. Syntax validation"
npm run lint
echo ""

echo "5. Tests with report"
TEST_REPORT_FILE="reports/test-report-local.txt" \
  npm run test:report
echo ""

echo "6. Package build"
PACKAGE_NAME="calculator-package-local" \
  npm run build
echo ""

echo "7. Package smoke test"

RESULT="$(
  node \
    dist/calculator-package-local/bin/cli.js \
    multiply \
    6 \
    7
)"

echo "CLI result: $RESULT"

if [ "$RESULT" != "42" ]; then
  echo "Unexpected package result."
  exit 1
fi

echo ""
echo "8. Generated files"

find reports dist \
  -maxdepth 4 \
  -type f \
  -print \
  | sort

echo ""
echo "Local multi-job CI completed successfully."