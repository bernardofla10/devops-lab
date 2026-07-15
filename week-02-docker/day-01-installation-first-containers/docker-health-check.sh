#!/usr/bin/env bash

set -euo pipefail

CONTAINER_NAME="${1:-nginx-day01}"
URL="${2:-http://localhost:8081}"

echo "Docker Container Health Check"
echo "============================="
echo ""

echo "Container: $CONTAINER_NAME"
echo "URL: $URL"
echo ""

echo "1. Checking if container exists..."
if docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  echo "Container exists."
else
  echo "Container does not exist."
  exit 1
fi

echo ""
echo "2. Checking if container is running..."
if docker ps --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  echo "Container is running."
else
  echo "Container is not running."
  exit 1
fi

echo ""
echo "3. Checking HTTP response..."
HTTP_STATUS=$(curl -s -o /tmp/docker-health-check.out -w "%{http_code}" "$URL" || true)

echo "HTTP status: $HTTP_STATUS"
echo "Response preview:"
head -n 5 /tmp/docker-health-check.out 2>/dev/null || true
echo ""

if [ "$HTTP_STATUS" = "200" ]; then
  echo "Health check passed."
else
  echo "Health check failed."
  exit 1
fi

echo ""
echo "4. Recent logs:"
docker logs --tail 10 "$CONTAINER_NAME"

echo ""
echo "Docker health check finished successfully."
