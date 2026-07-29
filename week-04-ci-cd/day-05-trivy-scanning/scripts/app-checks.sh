#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

APP_DIRECTORY="$PROJECT_DIRECTORY/app"

cd "$APP_DIRECTORY"

echo "Application Quality Checks"
echo "=========================="
echo ""

echo "1. Environment"
echo "Node: $(node --version)"
echo "npm:  $(npm --version)"
echo ""

echo "2. Clean dependency installation"
npm ci
echo ""

echo "3. Syntax validation"
npm run lint
echo ""

echo "4. Automated tests"
npm test
echo ""

echo "Application checks passed."