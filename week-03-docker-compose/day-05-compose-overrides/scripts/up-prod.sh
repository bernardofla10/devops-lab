#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

ENV_FILE="env/production.env"
PROJECT_NAME="devops-compose-day05-prod"

if [ ! -f "$ENV_FILE" ]; then
  cp env/production.env.example "$ENV_FILE"
fi

set -a
source "$ENV_FILE"
set +a

BASE_URL="http://${GATEWAY_BIND_IP:-127.0.0.1}:${GATEWAY_HOST_PORT:-8097}"

COMPOSE_ARGS=(
  -p "$PROJECT_NAME"
  --env-file "$ENV_FILE"
  -f compose.yaml
  -f compose.production.yaml
)

echo "Docker Compose Day 05 - Start Production"
echo "========================================"
echo ""

echo "1. Validating merged production configuration..."
docker compose "${COMPOSE_ARGS[@]}" config -q

echo "2. Building and starting production stack..."
docker compose "${COMPOSE_ARGS[@]}" up -d --build

echo "3. Waiting for health endpoint..."

for ATTEMPT in $(seq 1 30); do
  STATUS="$(
    curl -s \
      -o /tmp/day05-prod-health.json \
      -w "%{http_code}" \
      "$BASE_URL/health" \
      || true
  )"

  if [ "$STATUS" = "200" ]; then
    echo "Production stack is healthy."
    break
  fi

  echo "Attempt $ATTEMPT/30: not ready."
  sleep 2

  if [ "$ATTEMPT" -eq 30 ]; then
    docker compose "${COMPOSE_ARGS[@]}" logs --tail 50
    exit 1
  fi
done

echo ""
docker compose "${COMPOSE_ARGS[@]}" ps

echo ""
echo "Production gateway:"
echo "$BASE_URL"