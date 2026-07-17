#!/usr/bin/env bash

set -euo pipefail

IMAGE_NAME="devops-nginx"
IMAGE_TAG="day03"
FULL_IMAGE_NAME="${IMAGE_NAME}:${IMAGE_TAG}"
CONTAINER_NAME="dockerfile-nginx"
HOST_PORT="8083"

echo "Dockerfile Build, Run and Test Lab"
echo "=================================="
echo ""

echo "1. Building image: $FULL_IMAGE_NAME"
docker build -t "$FULL_IMAGE_NAME" .
echo ""

echo "2. Removing previous container if it exists..."
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
echo ""

echo "3. Starting container..."
docker run -d --name "$CONTAINER_NAME" -p "$HOST_PORT:80" "$FULL_IMAGE_NAME"
echo ""

echo "4. Waiting for Nginx to start..."
sleep 2
echo ""

echo "5. Testing root endpoint..."
curl -I "http://localhost:$HOST_PORT"
echo ""

echo "6. Testing health endpoint..."
HTTP_STATUS=$(curl -s -o /tmp/dockerfile-health.out -w "%{http_code}" "http://localhost:$HOST_PORT/health")

echo "HTTP status: $HTTP_STATUS"
echo "Response body:"
cat /tmp/dockerfile-health.out
echo ""

if [ "$HTTP_STATUS" = "200" ]; then
  echo "Health check passed."
else
  echo "Health check failed."
  exit 1
fi

echo ""
echo "7. Current containers:"
docker ps
echo ""

echo "8. Recent logs:"
docker logs --tail 20 "$CONTAINER_NAME"
echo ""

echo "Lab finished."
echo "Application available at: http://localhost:$HOST_PORT"