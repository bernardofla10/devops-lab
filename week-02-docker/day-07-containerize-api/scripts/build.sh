#!/usr/bin/env bash

set -euo pipefail

IMAGE_NAME="devops-api:week02-final"

echo "Building final Docker API image"
echo "==============================="
echo ""

docker build -t "$IMAGE_NAME" .

echo ""
echo "Image created:"
docker images | grep devops-api || true

echo ""
echo "Image history:"
docker history "$IMAGE_NAME"