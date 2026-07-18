#!/usr/bin/env bash

set -euo pipefail

IMAGE_NAME="devops-volumes-app:day05"
CONTAINER_NAME="volumes-named"
VOLUME_NAME="devops-data-day05"
HOST_PORT="8086"

echo "Named Volume Persistence Lab"
echo "============================"
echo ""

echo "1. Removing previous container..."
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

echo "2. Creating named volume..."
docker volume create "$VOLUME_NAME" >/dev/null

echo "3. Starting container with named volume..."
docker run -d \
  --name "$CONTAINER_NAME" \
  -p "$HOST_PORT:3000" \
  -e APP_NAME="$CONTAINER_NAME" \
  -e APP_ENV=named-volume \
  -v "$VOLUME_NAME:/data" \
  "$IMAGE_NAME"

sleep 2

echo ""
echo "4. Writing data..."
curl -s "http://localhost:$HOST_PORT/write?message=named-volume-message-1"
echo ""
curl -s "http://localhost:$HOST_PORT/write?message=named-volume-message-2"
echo ""

echo ""
echo "5. Reading data before removing container..."
curl -s "http://localhost:$HOST_PORT/data"
echo ""

echo ""
echo "6. Removing container..."
docker rm -f "$CONTAINER_NAME" >/dev/null

echo ""
echo "7. Recreating container with same volume..."
docker run -d \
  --name "$CONTAINER_NAME" \
  -p "$HOST_PORT:3000" \
  -e APP_NAME="${CONTAINER_NAME}-recreated" \
  -e APP_ENV=named-volume \
  -v "$VOLUME_NAME:/data" \
  "$IMAGE_NAME"

sleep 2

echo ""
echo "8. Reading data after recreating container..."
curl -s "http://localhost:$HOST_PORT/data"
echo ""

echo ""
echo "Expected result: previous data is still available."