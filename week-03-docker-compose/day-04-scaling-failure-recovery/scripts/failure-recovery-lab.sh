#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

if [ -f ".env" ]; then
  set -a
  source .env
  set +a
fi

GATEWAY_HOST_PORT="${GATEWAY_HOST_PORT:-8093}"
BASE_URL="http://localhost:${GATEWAY_HOST_PORT}"

echo "Docker Compose Day 04 - Failure Recovery Lab"
echo "============================================"
echo ""

TARGET_ID="$(docker compose ps -q api | head -n 1)"

if [ -z "$TARGET_ID" ]; then
  echo "No API replica is running."
  echo "Run ./scripts/up.sh first."
  exit 1
fi

TARGET_NAME="$(
  docker inspect \
    -f '{{trimPrefix "/" .Name}}' \
    "$TARGET_ID"
)"

RESTARTS_BEFORE="$(
  docker inspect \
    -f '{{.RestartCount}}' \
    "$TARGET_ID"
)"

echo "Target replica: $TARGET_NAME"
echo "Restart count before: $RESTARTS_BEFORE"
echo ""

echo "1. Checking gateway before failure..."
curl -s "$BASE_URL/health"
echo ""
echo ""

echo "2. Killing one API replica..."
docker kill "$TARGET_ID"
echo ""

echo "3. Checking gateway immediately after failure..."
curl -s "$BASE_URL/health" ||
  echo "Request temporarily failed."
echo ""
echo ""

echo "4. Waiting for automatic restart..."

for ATTEMPT in $(seq 1 20); do
  STATUS="$(
    docker inspect \
      -f '{{.State.Status}}' \
      "$TARGET_ID" \
      2>/dev/null \
      || echo "missing"
  )"

  HEALTH="$(
    docker inspect \
      -f '{{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}' \
      "$TARGET_ID" \
      2>/dev/null \
      || echo "missing"
  )"

  echo "Attempt $ATTEMPT/20: status=$STATUS health=$HEALTH"

  if [ "$STATUS" = "running" ] &&
     [ "$HEALTH" = "healthy" ]; then
    break
  fi

  sleep 2
done

RESTARTS_AFTER="$(
  docker inspect \
    -f '{{.RestartCount}}' \
    "$TARGET_ID"
)"

echo ""
echo "Restart count after: $RESTARTS_AFTER"
echo ""

echo "5. Current services:"
docker compose ps
echo ""

echo "6. Checking gateway after recovery..."
curl -s "$BASE_URL/health"
echo ""
echo ""

echo "7. Triggering application-level crash through the gateway..."
curl -s "$BASE_URL/crash" || true
echo ""
echo ""

sleep 4

echo "8. Service status after /crash:"
docker compose ps
echo ""

echo "9. Recent API logs:"
docker compose logs --tail 40 api
echo ""

echo "Failure recovery lab finished."