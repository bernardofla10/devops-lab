#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

PROJECT_NAME="devops-compose-day06-health"

COMPOSE_ARGS=(
  -p "$PROJECT_NAME"
  -f compose.yaml
  -f broken/compose.bad-healthcheck.yaml
)

echo "Broken Healthcheck Lab"
echo "======================"
echo ""

docker compose "${COMPOSE_ARGS[@]}" \
  down -v --remove-orphans \
  >/dev/null 2>&1 || true

set +e

docker compose "${COMPOSE_ARGS[@]}" \
  up \
  -d \
  --build \
  --wait \
  --wait-timeout 25

RESULT=$?

set -e

echo ""
echo "Compose exit code: $RESULT"
echo ""

echo "1. Service status:"
docker compose "${COMPOSE_ARGS[@]}" ps -a
echo ""

API_ID="$(
  docker compose "${COMPOSE_ARGS[@]}" ps -q api
)"

if [ -n "$API_ID" ]; then
  echo "2. API health details:"

  docker inspect \
    -f '{{json .State.Health}}' \
    "$API_ID"

  echo ""
fi

echo "3. API logs:"
docker compose "${COMPOSE_ARGS[@]}" \
  logs --tail 30 api || true

echo ""
echo "4. Cleaning lab..."

docker compose "${COMPOSE_ARGS[@]}" \
  down -v --remove-orphans \
  >/dev/null 2>&1 || true

if [ "$RESULT" -ne 0 ]; then
  echo "Expected unhealthy-service failure confirmed."
else
  echo "Unexpected success."
  exit 1
fi