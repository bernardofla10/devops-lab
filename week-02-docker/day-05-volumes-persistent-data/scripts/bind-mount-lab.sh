#!/usr/bin/env bash

set -euo pipefail

IMAGE_NAME="devops-volumes-app:day05"
CONTAINER_NAME="volumes-bind"
HOST_PORT="8086"
HOST_DATA_DIR="$PWD/host-data"

echo "Bind Mount Persistence Lab"
echo "=========================="
echo ""

echo "1. Removing previous container..."
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

echo "2. Creating host data directory..."
mkdir -p "$HOST_DATA_DIR"

echo "3. Starting container with bind mount..."
docker run -d \
  --name "$CONTAINER_NAME" \
  -p "$HOST_PORT:3000" \
  -e APP_NAME="$CONTAINER_NAME" \
  -e APP_ENV=bind-mount \
  -v "$HOST_DATA_DIR:/data" \
  "$IMAGE_NAME"

sleep 2

echo ""
echo "4. Writing data..."
curl -s "http://localhost:$HOST_PORT/write?message=bind-mount-message-1"
echo ""
curl -s "http://localhost:$HOST_PORT/write?message=bind-mount-message-2"
echo ""

echo ""
echo "5. Reading data through HTTP..."
curl -s "http://localhost:$HOST_PORT/data"
echo ""

echo ""
echo "6. Reading data directly from host directory..."
ls -la "$HOST_DATA_DIR"
echo ""
cat "$HOST_DATA_DIR/messages.json"

echo ""
echo "Expected result: messages.json exists on the host machine."