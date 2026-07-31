#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

TRIVY_IMAGE="${TRIVY_IMAGE:-aquasec/trivy:0.72.0}"
TRIVY_CACHE="${TRIVY_CACHE:-$HOME/.cache/trivy}"

mkdir -p "$TRIVY_CACHE"

echo "Trivy Dependency Security Gate"
echo "=============================="
echo ""

echo "Policy:"
echo "- type: library"
echo "- severity: HIGH,CRITICAL"
echo "- vulnerabilities with known fixes"
echo "- blocking exit code: 1"
echo ""

docker run --rm \
  -v "$PROJECT_DIRECTORY:/workspace:ro" \
  -v "$TRIVY_CACHE:/root/.cache/trivy" \
  "$TRIVY_IMAGE" \
  fs \
    --scanners vuln \
    --vuln-type library \
    --severity HIGH,CRITICAL \
    --ignore-unfixed \
    --exit-code 1 \
    /workspace/app

echo ""
echo "Trivy dependency security gate passed."