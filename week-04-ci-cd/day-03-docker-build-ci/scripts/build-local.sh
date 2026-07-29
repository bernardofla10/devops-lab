#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

cd "$PROJECT_DIRECTORY"

IMAGE_REFERENCE="${1:-devops-ci-api:local}"
BUILD_VERSION="${BUILD_VERSION:-local}"
BUILD_REVISION="${BUILD_REVISION:-$(git rev-parse HEAD 2>/dev/null || echo unknown)}"

echo "Docker CI API - Local Build"
echo "==========================="
echo ""
echo "Image:    $IMAGE_REFERENCE"
echo "Version:  $BUILD_VERSION"
echo "Revision: $BUILD_REVISION"
echo ""

echo "1. Docker Buildx version"
docker buildx version
echo ""

echo "2. Building and loading image"

docker buildx build \
  --load \
  --tag "$IMAGE_REFERENCE" \
  --build-arg "BUILD_VERSION=$BUILD_VERSION" \
  --build-arg "BUILD_REVISION=$BUILD_REVISION" \
  .

echo ""
echo "3. Image information"

docker image inspect \
  -f '
ID={{.Id}}
Created={{.Created}}
Architecture={{.Architecture}}
OS={{.Os}}
User={{.Config.User}}
Healthcheck={{json .Config.Healthcheck}}
' \
  "$IMAGE_REFERENCE"

echo ""
echo "Image built successfully."