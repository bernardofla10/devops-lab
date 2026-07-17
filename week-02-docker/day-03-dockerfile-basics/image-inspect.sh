#!/usr/bin/env bash

set -euo pipefail

IMAGE_NAME="${1:-devops-nginx:day03}"

echo "Docker Image Inspect Report"
echo "==========================="
echo ""

echo "Image: $IMAGE_NAME"
echo ""

echo "1. Checking if image exists..."
if ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
  echo "Image does not exist."
  exit 1
fi

echo "Image exists."
echo ""

echo "2. Image list entry:"
docker images "$IMAGE_NAME"
echo ""

echo "3. Image ID:"
docker image inspect -f '{{.Id}}' "$IMAGE_NAME"
echo ""

echo "4. Created at:"
docker image inspect -f '{{.Created}}' "$IMAGE_NAME"
echo ""

echo "5. Architecture and OS:"
echo "OS: $(docker image inspect -f '{{.Os}}' "$IMAGE_NAME")"
echo "Architecture: $(docker image inspect -f '{{.Architecture}}' "$IMAGE_NAME")"
echo ""

echo "6. Exposed ports:"
docker image inspect -f '{{json .Config.ExposedPorts}}' "$IMAGE_NAME"
echo ""

echo "7. Default command:"
docker image inspect -f '{{json .Config.Cmd}}' "$IMAGE_NAME"
echo ""

echo "8. Image layers/history:"
docker history "$IMAGE_NAME"
echo ""

echo "Image inspect report finished."