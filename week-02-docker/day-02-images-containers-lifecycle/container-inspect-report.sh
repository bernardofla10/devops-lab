#!/usr/bin/env bash

set -euo pipefail

CONTAINER_NAME="${1:-lifecycle-nginx-renamed}"

echo "Docker Container Inspect Report"
echo "==============================="
echo ""

echo "Container: $CONTAINER_NAME"
echo ""

echo "1. Checking if container exists..."
if ! docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  echo "Container does not exist."
  exit 1
fi

echo "Container exists."
echo ""

echo "2. Basic status:"
echo "Name: $CONTAINER_NAME"
echo "Status: $(docker inspect -f '{{.State.Status}}' "$CONTAINER_NAME")"
echo "Image: $(docker inspect -f '{{.Config.Image}}' "$CONTAINER_NAME")"
echo "Created at: $(docker inspect -f '{{.Created}}' "$CONTAINER_NAME")"
echo ""

echo "3. Network information:"
echo "IP address: $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$CONTAINER_NAME")"
echo ""

echo "4. Port bindings:"
docker port "$CONTAINER_NAME" || true
echo ""

echo "5. Processes:"
docker top "$CONTAINER_NAME" || true
echo ""

echo "6. Stats:"
docker stats --no-stream "$CONTAINER_NAME" || true
echo ""

echo "7. Recent logs:"
docker logs --tail 20 "$CONTAINER_NAME" || true
echo ""

echo "Inspect report finished."

