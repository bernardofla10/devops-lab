#!/usr/bin/env bash

set -euo pipefail

IMAGE_NAME="devops-api:week02-final"
CONTAINER_NAME="devops-api-day07"
NETWORK_NAME="devops-api-net-day07"
VOLUME_NAME="devops-api-data-day07"
HOST_PORT="8088"

echo "Final API Volume Persistence Lab"
echo "================================"
echo ""

echo "1. Creating network and volume..."
docker network create "$NETWORK_NAME" >/dev/null 2>&1 || true
docker volume create "$VOLUME_NAME" >/dev/null 2>&1 || true

echo "2. Starting container..."
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

docker run -d \
  --name "$CONTAINER_NAME" \
  --network "$NETWORK_NAME" \
  -p "$HOST_PORT:3000" \
  -e APP_NAME=containerized-api-volume-lab \
  -e APP_ENV=volume-test \
  -e PORT=3000 \
  -e DATA_DIR=/data \
  -v "$VOLUME_NAME:/data" \
  "$IMAGE_NAME"

sleep 3

echo ""
echo "3. Writing data..."
curl -s "http://localhost:$HOST_PORT/items/add?title=volume-persistence-test"
echo ""

echo ""
echo "4. Reading data before container removal..."
curl -s "http://localhost:$HOST_PORT/items"
echo ""

echo ""
echo "5. Removing container..."
docker rm -f "$CONTAINER_NAME" >/dev/null

echo ""
echo "6. Recreating container with same volume..."
docker run -d \
  --name "$CONTAINER_NAME" \
  --network "$NETWORK_NAME" \
  -p "$HOST_PORT:3000" \
  -e APP_NAME=containerized-api-volume-lab-recreated \
  -e APP_ENV=volume-test \
  -e PORT=3000 \
  -e DATA_DIR=/data \
  -v "$VOLUME_NAME:/data" \
  "$IMAGE_NAME"

sleep 3

echo ""
echo "7. Reading data after container recreation..."
curl -s "http://localhost:$HOST_PORT/items"
echo ""

echo ""
echo "Expected result: previously written data is still available."