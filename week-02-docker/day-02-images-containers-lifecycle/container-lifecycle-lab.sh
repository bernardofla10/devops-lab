#!/usr/bin/env bash

set -euo pipefail

CONTAINER_NAME="lifecycle-nginx"
IMAGE_NAME="nginx:alpine"
HOST_PORT="8082"

echo "Docker Lifecycle Lab"
echo "===================="
echo ""

echo "1. Pulling image..."
docker pull "$IMAGE_NAME"
echo ""

echo "2. Removing previous container if it exists..."
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
docker rm -f "${CONTAINER_NAME}-renamed" >/dev/null 2>&1 || true
echo ""

echo "3. Creating container without starting it..."
docker create --name "$CONTAINER_NAME" -p "$HOST_PORT:80" "$IMAGE_NAME"
echo ""

echo "Container status after create:"
docker inspect -f '{{.State.Status}}' "$CONTAINER_NAME"
echo ""

echo "4. Starting container..."
docker start "$CONTAINER_NAME"
echo ""

echo "Container status after start:"
docker inspect -f '{{.State.Status}}' "$CONTAINER_NAME"
echo ""

echo "5. Testing HTTP access..."
curl -I "http://localhost:$HOST_PORT"
echo ""

echo "6. Pausing container..."
docker pause "$CONTAINER_NAME"
echo "Status after pause:"
docker inspect -f '{{.State.Status}}' "$CONTAINER_NAME"
echo ""

echo "7. Unpausing container..."
docker unpause "$CONTAINER_NAME"
echo "Status after unpause:"
docker inspect -f '{{.State.Status}}' "$CONTAINER_NAME"
echo ""

echo "8. Generating logs..."
curl -s "http://localhost:$HOST_PORT" >/dev/null
curl -s "http://localhost:$HOST_PORT/teste" >/dev/null || true
echo ""

echo "9. Showing recent logs..."
docker logs --tail 10 "$CONTAINER_NAME"
echo ""

echo "10. Showing processes inside container..."
docker top "$CONTAINER_NAME"
echo ""

echo "11. Showing container stats once..."
docker stats --no-stream "$CONTAINER_NAME"
echo ""

echo "12. Copying file from host to container..."
echo "Hello from host machine" > /tmp/docker-host-file.txt
docker cp /tmp/docker-host-file.txt "$CONTAINER_NAME":/tmp/docker-host-file.txt
docker exec "$CONTAINER_NAME" cat /tmp/docker-host-file.txt
echo ""

echo "13. Copying file from container to host..."
docker cp "$CONTAINER_NAME":/usr/share/nginx/html/index.html /tmp/container-index.html
head /tmp/container-index.html 
echo ""

echo "14. Renaming container..."
docker rename "$CONTAINER_NAME" "${CONTAINER_NAME}-renamed"
echo ""

echo "15. Restarting renamed container..."
docker restart "${CONTAINER_NAME}-renamed"
echo ""

echo "16. Final container list:"
docker ps
echo ""

echo "Lifecycle lab finished."
echo "Container available at: http://localhost:$HOST_PORT"
echo ""
echo "To clean up, run:"
echo "./docker-cleanup-lifecycle.sh"