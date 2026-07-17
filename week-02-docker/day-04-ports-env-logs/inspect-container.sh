#!/usr/bin/env bash

set -euo pipefail

CONTAINER_NAME="${1:-env-app-day04}"

echo "Container Inspect Report"
echo "========================"
echo ""

echo "Container: $CONTAINER_NAME"
echo ""

if ! docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  echo "Container does not exist."
  exit 1
fi

echo "1. Status:"
docker inspect -f '{{.State.Status}}' "$CONTAINER_NAME"
echo ""

echo "2. Image:"
docker inspect -f '{{.Config.Image}}' "$CONTAINER_NAME"
echo ""

echo "3. Published ports:"
docker port "$CONTAINER_NAME" || true
echo ""

echo "4. Environment variables:"
docker inspect -f '{{range .Config.Env}}{{println .}}{{end}}' "$CONTAINER_NAME"
echo ""

echo "5. IP address:"
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$CONTAINER_NAME"
echo ""

echo "6. Running processes:"
docker top "$CONTAINER_NAME" || true
echo ""

echo "7. Resource usage:"
docker stats --no-stream "$CONTAINER_NAME" || true
echo ""

echo "8. Recent logs:"
docker logs --tail 15 "$CONTAINER_NAME"
echo ""

echo "Inspect finished."