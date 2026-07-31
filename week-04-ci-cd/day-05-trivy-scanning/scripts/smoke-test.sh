#!/usr/bin/env bash

set -euo pipefail

IMAGE_REFERENCE="${1:-trivy-security-lab:local}"
HOST_PORT="${2:-18085}"
CONTAINER_NAME="${3:-trivy-security-lab-test}"

cleanup() {
  EXIT_CODE=$?

  trap - EXIT

  echo ""
  echo "Container logs"
  echo "=============="

  docker logs "$CONTAINER_NAME" \
    2>&1 || true

  docker rm -f "$CONTAINER_NAME" \
    >/dev/null 2>&1 || true

  exit "$EXIT_CODE"
}

trap cleanup EXIT

echo "Container Smoke Test"
echo "===================="
echo ""
echo "Image: $IMAGE_REFERENCE"
echo "Port:  $HOST_PORT"
echo ""

docker rm -f "$CONTAINER_NAME" \
  >/dev/null 2>&1 || true

docker run -d \
  --name "$CONTAINER_NAME" \
  -p "127.0.0.1:${HOST_PORT}:3000" \
  -e APP_ENV=smoke-test \
  "$IMAGE_REFERENCE"

HEALTHY=false

for ATTEMPT in $(seq 1 20); do
  STATUS="$(
    docker inspect \
      -f '{{.State.Status}}' \
      "$CONTAINER_NAME"
  )"

  HEALTH="$(
    docker inspect \
      -f '{{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}' \
      "$CONTAINER_NAME"
  )"

  echo "Attempt $ATTEMPT/20: status=$STATUS health=$HEALTH"

  if [ "$HEALTH" = "healthy" ]; then
    HEALTHY=true
    break
  fi

  if [ "$STATUS" = "exited" ]; then
    echo "Container exited unexpectedly."
    exit 1
  fi

  sleep 2
done

if [ "$HEALTHY" != "true" ]; then
  echo "Container did not become healthy."
  exit 1
fi

BASE_URL="http://127.0.0.1:${HOST_PORT}"

echo ""
echo "Testing /health"

curl \
  --fail \
  --silent \
  --show-error \
  "$BASE_URL/health"

echo ""
echo ""
echo "Testing /version"

VERSION_RESPONSE="$(
  curl \
    --fail \
    --silent \
    --show-error \
    "$BASE_URL/version"
)"

echo "$VERSION_RESPONSE"

printf '%s\n' "$VERSION_RESPONSE" |
  grep -q '"lodashVersion"'

echo ""
echo "Container smoke test passed."