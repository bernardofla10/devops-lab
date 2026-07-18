#!/usr/bin/env bash

set -euo pipefail

API_CONTAINER="api-day06"
API_IMAGE="devops-network-api:day06"
CLIENT_IMAGE="devops-network-client:day06"

echo "Default Bridge Network Lab"
echo "=========================="
echo ""

echo "1. Removing previous API container..."
docker rm -f "$API_CONTAINER" >/dev/null 2>&1 || true

echo "2. Starting API on default bridge network..."
docker run -d \
  --name "$API_CONTAINER" \
  -p 8087:3000 \
  -e APP_NAME="$API_CONTAINER" \
  -e APP_ENV=default-bridge \
  "$API_IMAGE"

sleep 2

echo ""
echo "3. Testing API from host..."
curl -s http://localhost:8087/health
echo ""

echo ""
echo "4. Trying to call API by container name from another container on default bridge..."
set +e
docker run --rm \
  --name client-day06-default \
  -e TARGET_URL=http://api-day06:3000/health \
  "$CLIENT_IMAGE"
RESULT=$?
set -e

echo ""
if [ "$RESULT" -eq 0 ]; then
  echo "Client reached API. Your environment resolved the name on default bridge."
else
  echo "Client could not reach API by name on default bridge."
  echo "Use a custom Docker network for predictable container DNS."
fi

echo ""
echo "Default bridge lab finished."