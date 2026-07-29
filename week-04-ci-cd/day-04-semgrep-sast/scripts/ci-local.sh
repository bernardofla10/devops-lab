#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

APP_DIRECTORY="$PROJECT_DIRECTORY/app"

cd "$PROJECT_DIRECTORY"

echo "Week 04 Day 04 - Local DevSecOps CI"
echo "==================================="
echo ""

echo "1. Clean application installation"

cd "$APP_DIRECTORY"

npm ci

echo ""
echo "2. JavaScript syntax validation"

npm run lint

echo ""
echo "3. Automated application tests"

npm test

cd "$PROJECT_DIRECTORY"

echo ""
echo "4. Custom Semgrep rule tests"

./scripts/test-rules.sh

echo ""
echo "5. Semgrep reports"

rm -rf reports

./scripts/semgrep-report.sh

echo ""
echo "6. Semgrep blocking gate"

./scripts/semgrep-gate.sh

echo ""
echo "7. Docker build"

docker build \
  -t semgrep-sast-lab:local \
  .

echo ""
echo "Local DevSecOps CI completed successfully."