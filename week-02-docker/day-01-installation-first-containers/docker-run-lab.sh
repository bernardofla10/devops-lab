#!/usr/bin/env bash

set -euo pipefail

CONTAINER_NAME="nginx-day01"
HOST_PORT="8081"
IMAGE_NAME="nginx:alpine"

echo "Docker Day 01 Lab"
echo "================="
echo ""

echo "1. Checking Docker version..."
docker --version
echo ""

echo "2. Running hello-world..."
docker run hello-world
echo ""

echo "3. Running Alpine test container..."
docker run --rm alpine:latest sh -c 'echo "Hello from Alpine"; cat /etc/os-release | head -n 3'
echo ""

echo "4. Removing previous lab container if it exists..."
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
echo ""

echo "5. Pulling Nginx image..."
docker pull "$IMAGE_NAME"
echo ""

echo "6. Starting Nginx container..."
docker run -d --name "$CONTAINER_NAME" -p "$HOST_PORT:80" "$IMAGE_NAME"
echo ""

echo "7. Waiting for Nginx to start..."
sleep 2
echo ""

echo "8. Testing Nginx container..."
curl -I "http://localhost:$HOST_PORT"
echo ""

echo "9. Current running containers:"
docker ps
echo ""

echo "10. Recent container logs:"
docker logs --tail 20 "$CONTAINER_NAME"
echo ""

echo "Lab finished."
echo "Nginx is available at: http://localhost:$HOST_PORT"
echo ""
echo "To clean up, run:"
echo "./container-cleanup.sh"
