#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

IMAGE_REFERENCE="${1:-final-devsecops-api:local}"

TRIVY_IMAGE="${TRIVY_IMAGE:-aquasec/trivy:0.72.0}"
TRIVY_CACHE="${TRIVY_CACHE:-$HOME/.cache/trivy}"

REPORT_DIRECTORY="$PROJECT_DIRECTORY/reports/trivy-image"

mkdir -p "$TRIVY_CACHE"
mkdir -p "$REPORT_DIRECTORY"

run_trivy_image() {
  docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$TRIVY_CACHE:/root/.cache/trivy" \
    "$TRIVY_IMAGE" \
    image \
    "$@"
}

echo "Trivy Container Image Reports"
echo "============================="
echo ""
echo "Image: $IMAGE_REFERENCE"
echo ""

echo "1. Table report"

run_trivy_image \
  --scanners vuln \
  --vuln-type os,library \
  --severity UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL \
  --format table \
  "$IMAGE_REFERENCE" \
  | tee "$REPORT_DIRECTORY/trivy-image.txt"

echo ""
echo "2. JSON report"

run_trivy_image \
  --scanners vuln \
  --vuln-type os,library \
  --severity UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL \
  --format json \
  "$IMAGE_REFERENCE" \
  > "$REPORT_DIRECTORY/trivy-image.json"

echo "3. SARIF report"

run_trivy_image \
  --scanners vuln \
  --vuln-type os,library \
  --severity HIGH,CRITICAL \
  --format sarif \
  "$IMAGE_REFERENCE" \
  > "$REPORT_DIRECTORY/trivy-image.sarif"

FINDING_COUNT="$(
  jq '
    [
      .Results[]?.Vulnerabilities[]?
    ]
    | length
  ' "$REPORT_DIRECTORY/trivy-image.json"
)"

echo ""
echo "Image findings: $FINDING_COUNT"
