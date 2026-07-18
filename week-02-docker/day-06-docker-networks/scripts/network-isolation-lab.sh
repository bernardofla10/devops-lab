#!/usr/bin/env bash

set -euo pipefail

MAIN_NETWORK="devops-net-day06"
ISOLATED_NETWORK="isolated-net-day06"
API_CONTAINER="api-day06"
API_IMAGE="devops-network-api:day06"
CLIENT_IMAGE="devops-network-client:day06"

echo "Docker Network Isolation Lab"
echo "============================"
echo ""

echo "1. Creating networks..."
docker network create "$MAIN_NETWORK" >/dev/null 2>&1 || true
docker network create "$ISOLATED_NETWORK" >/dev/null 2>&1 || true

echo "2. Starting API on main network..."
docker rm -f "$API_CONTAINER" >/dev/null 2>&1 || true

docker run -d \
  --name "$API_CONTAINER" \
  --network "$MAIN_NETWORK" \
  -p 8087:3000 \
  -e APP_NAME="$API_CONTAINER" \
  -e APP_ENV=network-isolation \
  "$API_IMAGE"

sleep 2

echo ""
echo "3. Client on isolated network trying to reach API. This should fail..."
set +e
docker run --rm \
  --name client-isolated \
  --network "$ISOLATED_NETWORK" \
  -e TARGET_URL=http://api-day06:3000/health \
  "$CLIENT_IMAGE"
RESULT=$?
set -e

if [ "$RESULT" -ne 0 ]; then
  echo "Expected failure: client and API are in different networks."
fi

echo ""
echo "4. Connecting API to isolated network..."
docker network connect "$ISOLATED_NETWORK" "$API_CONTAINER"

echo ""
echo "5. Client on isolated network trying again. This should work..."
docker run --rm \
  --name client-isolated \
  --network "$ISOLATED_NETWORK" \
  -e TARGET_URL=http://api-day06:3000/health \
  "$CLIENT_IMAGE"

echo ""
echo "6. Disconnecting API from isolated network..."
docker network disconnect "$ISOLATED_NETWORK" "$API_CONTAINER"

echo ""
echo "Network isolation lab finished."