#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

MODE="${1:-all}"

echo "Docker Compose Day 03 - Start Stack"
echo "==================================="
echo ""

if [ ! -f ".env" ]; then
  echo ".env not found. Creating it from .env.example..."
  cp .env.example .env
fi

set -a
source .env
set +a

API_HOST_PORT="${API_HOST_PORT:-8091}"
ADMINER_HOST_PORT="${ADMINER_HOST_PORT:-8092}"
API_URL="http://localhost:${API_HOST_PORT}"
ADMINER_URL="http://localhost:${ADMINER_HOST_PORT}"

echo "1. Validating Compose configuration..."
docker compose --profile tools config -q
echo "Compose configuration is valid."
echo ""

if [ "$MODE" = "--core" ]; then
  echo "2. Starting core services: API and PostgreSQL..."
  docker compose up -d --build
  ADMINER_ENABLED=false
else
  echo "2. Starting API, PostgreSQL and Adminer..."
  docker compose --profile tools up -d --build
  ADMINER_ENABLED=true
fi

echo ""
echo "3. Waiting for API health..."

MAX_ATTEMPTS=30

for ATTEMPT in $(seq 1 "$MAX_ATTEMPTS"); do
  HTTP_STATUS=$(
    curl -s \
      -o /tmp/compose-day03-health.json \
      -w "%{http_code}" \
      "$API_URL/health" \
      || true
  )

  if [ "$HTTP_STATUS" = "200" ]; then
    echo "API is healthy."
    break
  fi

  echo "Attempt $ATTEMPT/$MAX_ATTEMPTS: API not ready."
  sleep 2

  if [ "$ATTEMPT" -eq "$MAX_ATTEMPTS" ]; then
    echo "API did not become healthy."
    docker compose --profile tools ps
    docker compose --profile tools logs --tail 50
    exit 1
  fi
done

if [ "$ADMINER_ENABLED" = true ]; then
  echo ""
  echo "4. Waiting for Adminer..."

  for ATTEMPT in $(seq 1 20); do
    ADMINER_STATUS=$(
      curl -s \
        -o /dev/null \
        -w "%{http_code}" \
        "$ADMINER_URL" \
        || true
    )

    if [ "$ADMINER_STATUS" = "200" ]; then
      echo "Adminer is available."
      break
    fi

    echo "Attempt $ATTEMPT/20: Adminer not ready."
    sleep 2
  done
fi

echo ""
echo "5. Current services:"
docker compose --profile tools ps
echo ""

echo "API:"
echo "$API_URL"

if [ "$ADMINER_ENABLED" = true ]; then
  echo ""
  echo "Adminer:"
  echo "$ADMINER_URL"
  echo ""
  echo "Adminer server: db"
fi