#!/usr/bin/env bash

set -euo pipefail

IMAGE_REFERENCE="${1:-trivy-security-lab:local}"
TRIVY_IMAGE="${TRIVY_IMAGE:-aquasec/trivy:0.72.0}"
TRIVY_CACHE="${TRIVY_CACHE:-$HOME/.cache/trivy}"

mkdir -p "$TRIVY_CACHE"

echo "Trivy Container Image Security Gate"
echo "==================================="
echo ""
echo "Image: $IMAGE_REFERENCE"
echo ""
echo "Policy:"
echo "- vulnerability types: os,library"
echo "- severity: CRITICAL"
echo "- fixed vulnerabilities only"
echo "- exit code 1 when blocked"
echo ""

docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$TRIVY_CACHE:/root/.cache/trivy" \
  "$TRIVY_IMAGE" \
  image \
    --scanners vuln \
    --vuln-type os,library \
    --severity CRITICAL \
    --ignore-unfixed \
    --exit-code 1 \
    "$IMAGE_REFERENCE"

echo ""
echo "Container image security gate passed."