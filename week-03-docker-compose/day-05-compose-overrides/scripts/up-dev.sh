#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

ENV_FILE="env/development.env"
PROJECT_NAME="devops-compose-day05-dev"

if [ ! -f "$ENV_FILE" ]; then
  cp env/development.env.example "$ENV_FILE"
fi

set -a
source "$ENV_FILE"
set +a

BASE_URL="http://${GATEWAY_BIND_IP:-127.0.0.1}:${GATEWAY_HOST_PORT:-8095}"

echo "Docker Compose Day 05 - Start Development"
echo "========================================="
echo ""

echo "1. Validating merged development configuration..."
docker compose \
  -p "$PROJECT_NAME" \
  --env-file "$ENV_FILE" \
  config -q

echo "2. Building and starting development stack..."
docker compose \
  -p "$PROJECT_NAME" \
  --env-file "$ENV_FILE" \
  up -d --build

echo "3. Waiting for health endpoint..."

for ATTEMPT in $(seq 1 30); do
  STATUS="$(
    curl -s \
      -o /tmp/day05-dev-health.json \
      -w "%{http_code}" \
      "$BASE_URL/health" \
      || true
  )"

  if [ "$STATUS" = "200" ]; then
    echo "Development stack is healthy."
    break
  fi

  echo "Attempt $ATTEMPT/30: not ready."
  sleep 2

  if [ "$ATTEMPT" -eq 30 ]; then
    docker compose \
      -p "$PROJECT_NAME" \
      --env-file "$ENV_FILE" \
      logs --tail 50

    exit 1
  fi
done

echo ""
docker compose \
  -p "$PROJECT_NAME" \
  --env-file "$ENV_FILE" \
  ps

echo ""
echo "Gateway:    $BASE_URL"
echo "Direct API: http://127.0.0.1:${API_DIRECT_PORT:-8096}"
echo "PostgreSQL: 127.0.0.1:${POSTGRES_HOST_PORT:-5433}"