#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

if [ -f ".env" ]; then
  set -a
  source .env
  set +a
fi

API_HOST_PORT="${API_HOST_PORT:-8090}"
BASE_URL="http://localhost:${API_HOST_PORT}"

echo "Docker Compose Day 02 - API and PostgreSQL Tests"
echo "================================================"
echo ""
echo "Base URL: $BASE_URL"
echo ""

echo "1. GET /health"
HEALTH_STATUS=$(
  curl -s \
    -o /tmp/compose-day02-health.json \
    -w "%{http_code}" \
    "$BASE_URL/health"
)

cat /tmp/compose-day02-health.json
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

echo "3. GET /db-info"
curl -s "$BASE_URL/db-info"
echo ""
echo ""

echo "4. GET /items"
curl -s "$BASE_URL/items"
echo ""
echo ""

echo "5. Add first item"
curl -s "$BASE_URL/items/add?title=compose-postgres-script-item-1"
echo ""
echo ""

echo "6. Add second item"
curl -s "$BASE_URL/items/add?title=compose-postgres-script-item-2"
echo ""
echo ""

echo "7. GET /items after inserts"
curl -s "$BASE_URL/items"
echo ""
echo ""

echo "8. GET /error"
ERROR_STATUS=$(
  curl -s \
    -o /tmp/compose-day02-error.json \
    -w "%{http_code}" \
    "$BASE_URL/error"
)

cat /tmp/compose-day02-error.json
echo ""
echo "HTTP status: $ERROR_STATUS"
echo ""

if [ "$ERROR_STATUS" != "500" ]; then
  echo "Expected HTTP 500 from /error."
  exit 1
fi

echo "All tests finished successfully."