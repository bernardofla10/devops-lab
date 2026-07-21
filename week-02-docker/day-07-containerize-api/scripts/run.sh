#!/usr/bin/env bash

set -euo pipefail

IMAGE_NAME="devops-api:week02-final"
CONTAINER_NAME="devops-api-day07"
NETWORK_NAME="devops-api-net-day07"
VOLUME_NAME="devops-api-data-day07"
HOST_PORT="8088"
CONTAINER_PORT="3000"
ENV_FILE=".env"

echo "Running final Docker API container"
echo "=================================="
echo ""

echo "1. Creating network and volume if needed..."
docker network create "$NETWORK_NAME" >/dev/null 2>&1 || true
docker volume create "$VOLUME_NAME" >/dev/null 2>&1 || true

echo "2. Removing previous container if it exists..."
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

echo "3. Starting container..."
if [ -f "$ENV_FILE" ]; then
  docker run -d \
    --name "$CONTAINER_NAME" \
    --network "$NETWORK_NAME" \
    -p "$HOST_PORT:$CONTAINER_PORT" \
    --env-file "$ENV_FILE" \
    -v "$VOLUME_NAME:/data" \
    "$IMAGE_NAME"
else
  docker run -d \
    --name "$CONTAINER_NAME" \
    --network "$NETWORK_NAME" \
    -p "$HOST_PORT:$CONTAINER_PORT" \
    -e APP_NAME=containerized-api-final-lab \
    -e APP_ENV=local \
    -e PORT="$CONTAINER_PORT" \
    -e DATA_DIR=/data \
    -v "$VOLUME_NAME:/data" \
    "$IMAGE_NAME"
fi

echo ""
echo "4. Waiting for API to start..."
sleep 3

echo ""
echo "5. Container status:"
docker ps --filter "name=$CONTAINER_NAME"

echo ""
echo "6. Application available at:"
echo "http://localhost:$HOST_PORT"