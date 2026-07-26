#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo "Docker Compose Day 04 - Start Scalable Stack"
echo "============================================"
echo ""

if [ ! -f ".env" ]; then
  echo ".env not found. Creating it from .env.example..."
  cp .env.example .env
fi

set -a
source .env
set +a

API_REPLICAS="${API_REPLICAS:-3}"
GATEWAY_HOST_PORT="${GATEWAY_HOST_PORT:-8093}"
BASE_URL="http://localhost:${GATEWAY_HOST_PORT}"

echo "1. Validating Compose configuration..."
docker compose config -q
echo "Compose configuration is valid."
echo ""

echo "2. Building and starting the stack..."
docker compose up \
  -d \
  --build \
  --scale "api=${API_REPLICAS}"
echo ""

echo "3. Restarting gateway to resolve current API replicas..."
docker compose restart gateway
echo ""

echo "4. Waiting for gateway and API..."

MAX_ATTEMPTS=30

for ATTEMPT in $(seq 1 "$MAX_ATTEMPTS"); do
  HTTP_STATUS=$(
    curl -s \
      -o /tmp/day04-health.json \
      -w "%{http_code}" \
      "$BASE_URL/health" \
      || true
  )

  if [ "$HTTP_STATUS" = "200" ]; then
    echo "Stack is healthy."
    echo ""
    cat /tmp/day04-health.json
    echo ""
    break
  fi

  echo "Attempt $ATTEMPT/$MAX_ATTEMPTS: stack not ready."
  sleep 2

  if [ "$ATTEMPT" -eq "$MAX_ATTEMPTS" ]; then
    echo "Stack did not become healthy."
    echo ""
    docker compose ps
    echo ""
    docker compose logs --tail 50
    exit 1
  fi
done

echo ""
echo "5. Current services:"
docker compose ps
echo ""

echo "Gateway URL:"
echo "$BASE_URL"
echo ""

echo "API replicas requested:"
echo "$API_REPLICAS"