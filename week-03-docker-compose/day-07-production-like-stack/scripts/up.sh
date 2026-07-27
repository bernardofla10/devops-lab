#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

MODE="${1:-dev}"
TOOLS="${2:-}"

case "$MODE" in
  dev)
    PROJECT_NAME="devops-compose-day07-dev"
    ENV_FILE="env/development.env"

    COMPOSE_ARGS=(
      -p "$PROJECT_NAME"
      --env-file "$ENV_FILE"
    )
    ;;

  prod)
    PROJECT_NAME="devops-compose-day07-prod"
    ENV_FILE="env/production.env"

    COMPOSE_ARGS=(
      -p "$PROJECT_NAME"
      --env-file "$ENV_FILE"
      -f compose.yaml
      -f compose.production.yaml
    )
    ;;

  *)
    echo "Usage: ./scripts/up.sh dev|prod [--tools]"
    exit 1
    ;;
esac

if [ ! -f "$ENV_FILE" ]; then
  cp "${ENV_FILE}.example" "$ENV_FILE"
fi

if [ ! -f "secrets/db_password.txt" ]; then
  cp secrets/db_password.example secrets/db_password.txt
  chmod 600 secrets/db_password.txt
fi

set -a
source "$ENV_FILE"
set +a

if [ "$TOOLS" = "--tools" ]; then
  COMPOSE_ARGS+=(--profile tools)
fi

BASE_URL="http://${GATEWAY_BIND_IP:-127.0.0.1}:${GATEWAY_HOST_PORT}"

echo "Production-like Compose Stack"
echo "============================="
echo ""
echo "Mode: $MODE"
echo ""

echo "1. Validating configuration..."
docker compose "${COMPOSE_ARGS[@]}" config -q
echo "Configuration is valid."
echo ""

echo "2. Building and starting services..."
docker compose "${COMPOSE_ARGS[@]}" up -d --build
echo ""

echo "3. Waiting for readiness..."

for ATTEMPT in $(seq 1 40); do
  STATUS="$(
    curl -s \
      -o /tmp/day07-ready.json \
      -w "%{http_code}" \
      "$BASE_URL/ready" \
      || true
  )"

  if [ "$STATUS" = "200" ]; then
    echo "Stack is ready."
    break
  fi

  echo "Attempt $ATTEMPT/40: stack not ready."
  sleep 2

  if [ "$ATTEMPT" -eq 40 ]; then
    docker compose "${COMPOSE_ARGS[@]}" ps -a
    docker compose "${COMPOSE_ARGS[@]}" logs --tail 50
    exit 1
  fi
done

echo ""
echo "4. Service status:"
docker compose "${COMPOSE_ARGS[@]}" ps -a
echo ""

echo "Gateway:"
echo "$BASE_URL"