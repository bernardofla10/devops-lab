#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

cd "$PROJECT_DIRECTORY"

IMAGE_REFERENCE="final-devsecops-api:local"

echo "Week 04 Day 07 - Local DevSecOps Pipeline"
echo "========================================="
echo ""

echo "1. Cleaning generated output"

rm -rf reports artifacts downloaded-image

echo ""
echo "2. Workflow security"

./scripts/workflow-checks.sh

echo ""
echo "3. Application quality"

./scripts/app-checks.sh

echo ""
echo "4. Semgrep reports"

./scripts/semgrep-report.sh

echo ""
echo "5. Semgrep security gate"

./scripts/semgrep-gate.sh

echo ""
echo "6. Trivy filesystem reports"

./scripts/trivy-fs-report.sh

echo ""
echo "7. Trivy dependency gate"

./scripts/trivy-fs-gate.sh

echo ""
echo "8. Docker build"

BUILD_VERSION="local-ci" \
  ./scripts/build-image.sh \
    "$IMAGE_REFERENCE"

echo ""
echo "9. Trivy image reports"

./scripts/trivy-image-report.sh \
  "$IMAGE_REFERENCE"

echo ""
echo "10. Trivy image gate"

./scripts/trivy-image-gate.sh \
  "$IMAGE_REFERENCE"

echo ""
echo "11. Container smoke test"

./scripts/smoke-test.sh \
  "$IMAGE_REFERENCE" \
  18087 \
  final-devsecops-local-test

echo ""
echo "12. Exporting Docker image"

./scripts/export-image.sh \
  "$IMAGE_REFERENCE" \
  artifacts

echo ""
echo "13. Generated evidence"

find reports artifacts \
  -maxdepth 4 \
  -type f \
  -print \
  | sort

echo ""
echo "Local DevSecOps pipeline completed successfully."