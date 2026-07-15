#!/usr/bin/env bash

set -euo pipefail

CONTAINER_NAME="${1:-nginx-day01}"

echo "Docker Container Cleanup"
echo "========================"
echo ""

echo "Removing container if it exists: $CONTAINER_NAME"
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

echo ""
echo "Remaining containers:"
docker ps -a

echo ""
echo "Cleanup finished."