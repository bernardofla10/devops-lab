#!/usr/bin/env bash

set -euo pipefail

CONTAINER_NAME="dockerfile-nginx"

echo "Dockerfile Lab Cleanup"
echo "======================"
echo ""

echo "Removing container if it exists..."
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

echo ""
echo "Containers:"
docker ps -a

echo ""
echo "Images matching devops-nginx:"
docker images | grep devops-nginx || echo "No devops-nginx images found."

echo ""
echo "To remove the image manually, run:"
echo "docker rmi devops-nginx:day03"
echo ""
echo "Cleanup finished."