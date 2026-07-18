#!/usr/bin/env bash

set -euo pipefail

IMAGE_NAME="devops-volumes-app:day05"

echo "Building Docker image: $IMAGE_NAME"
docker build -t "$IMAGE_NAME" .

echo ""
echo "Image created:"
docker images | grep devops-volumes-app