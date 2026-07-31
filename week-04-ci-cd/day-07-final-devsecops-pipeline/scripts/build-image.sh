#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

cd "$PROJECT_DIRECTORY"

IMAGE_REFERENCE="${1:-final-devsecops-api:local}"

BUILD_VERSION="${BUILD_VERSION:-local}"

BUILD_REVISION="${BUILD_REVISION:-$(
    git rev-parse HEAD 2>/dev/null ||
      echo unknown
  )}"

echo "Final DevSecOps Docker Build"
echo "============================"
echo ""
echo "Image:    $IMAGE_REFERENCE"
echo "Version:  $BUILD_VERSION"
echo "Revision: $BUILD_REVISION"
echo ""

docker buildx build \
  --load \
  --tag "$IMAGE_REFERENCE" \
  --build-arg "BUILD_VERSION=$BUILD_VERSION" \
  --build-arg "BUILD_REVISION=$BUILD_REVISION" \
  .

echo ""
echo "Image configuration:"

docker image inspect \
  -f '
ID={{.Id}}
Created={{.Created}}
User={{.Config.User}}
Architecture={{.Architecture}}
OS={{.Os}}
Healthcheck={{json .Config.Healthcheck}}
' \
  "$IMAGE_REFERENCE"

echo ""
echo "Docker image built successfully."
