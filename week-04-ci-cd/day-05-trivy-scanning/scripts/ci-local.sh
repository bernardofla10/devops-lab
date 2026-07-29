#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

cd "$PROJECT_DIRECTORY"

IMAGE_REFERENCE="trivy-security-lab:local"

echo "Week 04 Day 05 - Local Trivy CI"
echo "==============================="
echo ""

echo "1. Cleaning generated reports"
rm -rf reports
echo ""

echo "2. Application checks"
./scripts/app-checks.sh
echo ""

echo "3. Filesystem vulnerability reports"
./scripts/fs-report.sh
echo ""

echo "4. Dependency security gate"
./scripts/fs-gate.sh
echo ""

echo "5. Docker image build"
./scripts/build-image.sh "$IMAGE_REFERENCE"
echo ""

echo "6. Container image reports"
./scripts/image-report.sh "$IMAGE_REFERENCE"
echo ""

echo "7. Container image security gate"
./scripts/image-gate.sh "$IMAGE_REFERENCE"
echo ""

echo "8. Container smoke test"
./scripts/smoke-test.sh \
  "$IMAGE_REFERENCE" \
  18085 \
  trivy-security-lab-local-test

echo ""
echo "Local Trivy CI completed successfully."