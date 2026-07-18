#!/usr/bin/env bash

set -euo pipefail

CONTAINER_NAME="${1:-volumes-bind}"
VOLUME_NAME="${2:-devops-data-day05}"

echo "Docker Volumes Inspect Report"
echo "============================="
echo ""

echo "1. Docker volumes:"
docker volume ls
echo ""

echo "2. Inspecting named volume if it exists: $VOLUME_NAME"
if docker volume inspect "$VOLUME_NAME" >/dev/null 2>&1; then
  docker volume inspect "$VOLUME_NAME"
else
  echo "Volume not found: $VOLUME_NAME"
fi
echo ""

echo "3. Inspecting container mounts if container exists: $CONTAINER_NAME"
if docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  docker inspect "$CONTAINER_NAME" | grep -A 25 '"Mounts"'
  echo ""
  echo "Container port bindings:"
  docker port "$CONTAINER_NAME" || true
  echo ""
  echo "Recent logs:"
  docker logs --tail 10 "$CONTAINER_NAME" || true
else
  echo "Container not found: $CONTAINER_NAME"
fi

echo ""
echo "Inspect finished."