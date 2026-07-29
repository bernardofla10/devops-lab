#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

cd "$PROJECT_DIRECTORY"

IMAGE_REFERENCE="${1:-trivy-security-lab:local}"

echo "Docker Image Build"
echo "=================="
echo ""
echo "Image: $IMAGE_REFERENCE"
echo ""

docker build \
  --tag "$IMAGE_REFERENCE" \
  .

echo ""
docker image inspect \
  -f '
ID={{.Id}}
Created={{.Created}}
User={{.Config.User}}
Architecture={{.Architecture}}
OS={{.Os}}
' \
  "$IMAGE_REFERENCE"

echo ""
echo "Image built successfully."