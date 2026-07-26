#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

if [ -f ".env" ]; then
  set -a
  source .env
  set +a
fi

API_HOST_PORT="${API_HOST_PORT:-8091}"
ADMINER_HOST_PORT="${ADMINER_HOST_PORT:-8092}"

API_URL="http://localhost:${API_HOST_PORT}"
ADMINER_URL="http://localhost:${ADMINER_HOST_PORT}"

echo "Docker Compose Day 03 - Integration Tests"
echo "========================================="
echo ""

echo "1. API health"
API_STATUS=$(
  curl -s \
    -o /tmp/day03-api-health.json \
    -w "%{http_code}" \
    "$API_URL/health"
)

cat /tmp/day03-api-health.json
echo ""
echo "HTTP status: $API_STATUS"
echo ""

if [ "$API_STATUS" != "200" ]; then
  echo "API health test failed."
  exit 1
fi

echo "2. PostgreSQL information"
curl -s "$API_URL/db-info"
echo ""
echo ""

echo "3. Insert item through API"
curl -s "$API_URL/items/add?title=day03-integration-test"
echo ""
echo ""

echo "4. Read items"
curl -s "$API_URL/items"
echo ""
echo ""

echo "5. Database readiness"
docker compose exec -T db sh -c '
  pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB"
'
echo ""

echo "6. Adminer availability"

if docker compose --profile tools ps \
  --services \
  --status running |
  grep -qx "adminer"; then

  ADMINER_STATUS=$(
    curl -s \
      -o /dev/null \
      -w "%{http_code}" \
      "$ADMINER_URL"
  )

  echo "Adminer HTTP status: $ADMINER_STATUS"

  if [ "$ADMINER_STATUS" != "200" ]; then
    echo "Adminer test failed."
    exit 1
  fi
else
  echo "Adminer is not running. Start the tools profile to test it."
fi

echo ""
echo "All integration tests finished successfully."