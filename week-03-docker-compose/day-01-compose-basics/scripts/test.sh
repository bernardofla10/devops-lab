#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

if [ -f ".env" ]; then
  set -a
  source .env
  set +a
fi

HOST_PORT="${HOST_PORT:-8089}"
BASE_URL="http://localhost:${HOST_PORT}"

echo "Docker Compose Day 01 - API Tests"
echo "================================="
echo ""
echo "Base URL: $BASE_URL"
echo ""

echo "1. GET /health"
HEALTH_STATUS=$(
  curl -s \
    -o /tmp/compose-day01-health.json \
    -w "%{http_code}" \
    "$BASE_URL/health"
)

cat /tmp/compose-day01-health.json
echo ""
echo "HTTP status: $HEALTH_STATUS"
echo ""

if [ "$HEALTH_STATUS" != "200" ]; then
  echo "Health check failed."
  exit 1
fi

echo "2. GET /config"
curl -s "$BASE_URL/config"
echo ""
echo ""

echo "3. Add item"
curl -s "$BASE_URL/items/add?title=compose-script-test-item"
echo ""
echo ""

echo "4. GET /items"
curl -s "$BASE_URL/items"
echo ""
echo ""

echo "5. GET /error"
ERROR_STATUS=$(
  curl -s \
    -o /tmp/compose-day01-error.json \
    -w "%{http_code}" \
    "$BASE_URL/error"
)

cat /tmp/compose-day01-error.json
echo ""
echo "HTTP status: $ERROR_STATUS"
echo ""

if [ "$ERROR_STATUS" != "500" ]; then
  echo "Expected HTTP 500 from simulated error endpoint."
  exit 1
fi

echo "All API tests finished successfully."