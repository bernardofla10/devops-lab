#!/usr/bin/env bash

set -euo pipefail

IMAGE_NAME="devops-volumes-app:day05"
CONTAINER_NAME="volumes-ephemeral"
HOST_PORT="8086"

echo "Ephemeral Container Data Lab"
echo "============================"
echo ""

echo "1. Removing previous container..."
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

echo "2. Starting container without volume..."
docker run -d \
  --name "$CONTAINER_NAME" \
  -p "$HOST_PORT:3000" \
  -e APP_NAME="$CONTAINER_NAME" \
  -e APP_ENV=ephemeral \
  "$IMAGE_NAME"

sleep 2

echo ""
echo "3. Writing data..."
curl -s "http://localhost:$HOST_PORT/write?message=ephemeral-message"
echo ""

echo ""
echo "4. Reading data before removing container..."
curl -s "http://localhost:$HOST_PORT/data"
echo ""

echo ""
echo "5. Removing container..."
docker rm -f "$CONTAINER_NAME" >/dev/null

echo ""
echo "6. Recreating container without volume..."
docker run -d \
  --name "$CONTAINER_NAME" \
  -p "$HOST_PORT:3000" \
  -e APP_NAME="$CONTAINER_NAME" \
  -e APP_ENV=ephemeral \
  "$IMAGE_NAME"

sleep 2

echo ""
echo "7. Reading data after recreating container..."
curl -s "http://localhost:$HOST_PORT/data"
echo ""

echo ""
echo "Expected result: previous data is gone."