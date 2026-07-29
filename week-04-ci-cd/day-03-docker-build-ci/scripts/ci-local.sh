#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

APP_DIRECTORY="$PROJECT_DIRECTORY/app"
IMAGE_REFERENCE="devops-ci-api:local"

cd "$PROJECT_DIRECTORY"

echo "Week 04 Day 03 - Local Docker CI"
echo "================================"
echo ""

echo "1. Cleaning generated files"

rm -rf reports artifacts

echo ""
echo "2. Application quality checks"

cd "$APP_DIRECTORY"

npm ci
npm run lint
npm test

cd "$PROJECT_DIRECTORY"

echo ""
echo "3. Docker image build"

BUILD_VERSION="local-ci" \
  ./scripts/build-local.sh "$IMAGE_REFERENCE"

echo ""
echo "4. Container smoke tests"

REPORT_FILE="reports/local-smoke-test.txt" \
  ./scripts/test-container.sh \
    "$IMAGE_REFERENCE" \
    18080 \
    devops-ci-api-local-test

echo ""
echo "5. Image export"

./scripts/export-image.sh \
  "$IMAGE_REFERENCE" \
  artifacts

echo ""
echo "6. Generated files"

find reports artifacts \
  -maxdepth 3 \
  -type f \
  -print \
  | sort

echo ""
echo "Local Docker CI completed successfully."