#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

APP_DIRECTORY="$PROJECT_DIRECTORY/app"

cd "$APP_DIRECTORY"

echo "Application Quality Gate"
echo "========================"
echo ""

echo "1. Environment"
echo "Node: $(node --version)"
echo "npm:  $(npm --version)"
echo ""

echo "2. Clean dependency installation"

npm ci --ignore-scripts

echo ""
echo "3. JavaScript syntax validation"

npm run lint

echo ""
echo "4. Automated tests"

"$PROJECT_DIRECTORY/scripts/test-with-report.sh"

echo ""
echo "Application quality gate passed."