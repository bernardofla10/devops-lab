#!/usr/bin/env bash

set -euo pipefail

IMAGE_NAME="devops-env-app:day04"
CONTAINER_NAME="env-app-day04"
HOST_PORT="8084"
CONTAINER_PORT="3000"

echo "Docker Ports, Environment Variables and Logs Lab"
echo "================================================"
echo ""

echo "1. Building image: $IMAGE_NAME"
docker build -t "$IMAGE_NAME" .
echo ""

echo "2. Removing previous container if it exists..."
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
echo ""

echo "3. Starting container with environment variables..."
docker run -d \
  --name "$CONTAINER_NAME" \
  -p "$HOST_PORT:$CONTAINER_PORT" \
  -e APP_NAME=devops-env-app \
  -e APP_ENV=development \
  -e APP_MESSAGE="Hello from Docker environment variables" \
  -e PORT="$CONTAINER_PORT" \
  "$IMAGE_NAME"
echo ""

echo "4. Waiting for application to start..."
sleep 2
echo ""

echo "5. Testing endpoints..."
curl -s "http://localhost:$HOST_PORT" | head
echo ""
curl -s "http://localhost:$HOST_PORT/health"
echo ""
curl -s "http://localhost:$HOST_PORT/config"
echo ""
echo ""

echo "6. Checking published ports..."
docker port "$CONTAINER_NAME"
echo ""

echo "7. Recent logs:"
docker logs --tail 20 "$CONTAINER_NAME"
echo ""

echo "Lab finished."
echo "Application available at: http://localhost:$HOST_PORT"