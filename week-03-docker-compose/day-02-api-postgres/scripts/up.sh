#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo "Docker Compose Day 02 - Start API and PostgreSQL"
echo "================================================"
echo ""

if [ ! -f ".env" ]; then
  echo ".env not found. Creating it from .env.example..."
  cp .env.example .env
fi

set -a
source .env
set +a

API_HOST_PORT="${API_HOST_PORT:-8090}"
BASE_URL="http://localhost:${API_HOST_PORT}"

echo "1. Validating Compose configuration..."
docker compose config >/dev/null
echo "Compose configuration is valid."
echo ""

echo "2. Building and starting services..."
docker compose up -d --build
echo ""

echo "3. Waiting for the API health endpoint..."

MAX_ATTEMPTS=30

for ATTEMPT in $(seq 1 "$MAX_ATTEMPTS"); do
  HTTP_STATUS=$(
    curl -s \
      -o /tmp/compose-day02-health.json \
      -w "%{http_code}" \
      "$BASE_URL/health" \
      || true
  )

  if [ "$HTTP_STATUS" = "200" ]; then
    echo "API is healthy."
    echo ""
    cat /tmp/compose-day02-health.json
    echo ""
    break
  fi

  echo "Attempt $ATTEMPT/$MAX_ATTEMPTS: API not ready yet."
  sleep 2

  if [ "$ATTEMPT" -eq "$MAX_ATTEMPTS" ]; then
    echo "API did not become healthy."
    echo ""
    docker compose ps
    echo ""
    docker compose logs --tail 50
    exit 1
  fi
done

echo ""
echo "4. Current services:"
docker compose ps
echo ""

echo "5. API URL:"
echo "$BASE_URL"