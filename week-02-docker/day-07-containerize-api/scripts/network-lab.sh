#!/usr/bin/env bash

set -euo pipefail

CONTAINER_NAME="devops-api-day07"
NETWORK_NAME="devops-api-net-day07"

echo "Final API Docker Network Lab"
echo "============================"
echo ""

echo "1. Checking API container..."
if ! docker ps --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  echo "Container is not running: $CONTAINER_NAME"
  echo "Run ./scripts/run.sh first."
  exit 1
fi

echo "2. Calling API from another container in the same network..."
docker run --rm \
  --network "$NETWORK_NAME" \
  node:20-alpine \
  node -e "require('http').get('http://devops-api-day07:3000/health', res => { let d=''; res.on('data', c => d+=c); res.on('end', () => { console.log(d); process.exit(res.statusCode === 200 ? 0 : 1); }); }).on('error', err => { console.error(err.message); process.exit(1); })"

echo ""
echo "3. Testing localhost from inside another container. This is expected to fail..."
set +e
docker run --rm \
  --network "$NETWORK_NAME" \
  node:20-alpine \
  node -e "require('http').get('http://localhost:3000/health', res => console.log(res.statusCode)).on('error', err => { console.error(err.message); process.exit(1); })"
RESULT=$?
set -e

if [ "$RESULT" -ne 0 ]; then
  echo "Expected failure confirmed: localhost inside a container points to itself."
fi

echo ""
echo "Network lab finished."