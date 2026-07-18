#!/usr/bin/env bash

set -euo pipefail

NETWORK_NAME="devops-net-day06"
API_CONTAINER="api-day06"
API_IMAGE="devops-network-api:day06"
CLIENT_IMAGE="devops-network-client:day06"

echo "Custom Docker Network Lab"
echo "========================="
echo ""

echo "1. Creating custom network if needed..."
docker network create "$NETWORK_NAME" >/dev/null 2>&1 || true

echo "2. Removing previous API container..."
docker rm -f "$API_CONTAINER" >/dev/null 2>&1 || true

echo "3. Starting API on custom network..."
docker run -d \
  --name "$API_CONTAINER" \
  --network "$NETWORK_NAME" \
  -p 8087:3000 \
  -e APP_NAME="$API_CONTAINER" \
  -e APP_ENV=custom-network \
  "$API_IMAGE"

sleep 2

echo ""
echo "4. Testing API from host..."
curl -s http://localhost:8087/health
echo ""

echo ""
echo "5. Testing client -> API using container name..."
docker run --rm \
  --name client-day06 \
  --network "$NETWORK_NAME" \
  -e TARGET_URL=http://api-day06:3000/health \
  "$CLIENT_IMAGE"

echo ""
echo "6. Testing client -> API /info..."
docker run --rm \
  --name client-day06-info \
  --network "$NETWORK_NAME" \
  -e TARGET_URL=http://api-day06:3000/info \
  "$CLIENT_IMAGE"

echo ""
echo "7. Testing localhost from client. This is expected to fail..."
set +e
docker run --rm \
  --name client-localhost-test \
  --network "$NETWORK_NAME" \
  -e TARGET_URL=http://localhost:3000/health \
  "$CLIENT_IMAGE"
RESULT=$?
set -e

if [ "$RESULT" -ne 0 ]; then
  echo "Expected failure: localhost inside client is not the API container."
fi

echo ""
echo "Custom network lab finished."