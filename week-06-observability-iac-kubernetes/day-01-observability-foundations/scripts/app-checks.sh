#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

APP_DIRECTORY="$PROJECT_DIRECTORY/app"

cd "$APP_DIRECTORY"

echo "Observability Application Checks"
echo "================================"
echo ""

echo "1. Runtime"
echo "Node: $(node --version)"
echo "npm:  $(npm --version)"
echo ""

echo "2. Clean dependency installation"

npm ci --ignore-scripts

echo ""
echo "3. JavaScript syntax"

npm run lint

echo ""
echo "4. Automated tests"

npm test

echo ""
echo "Application checks passed."