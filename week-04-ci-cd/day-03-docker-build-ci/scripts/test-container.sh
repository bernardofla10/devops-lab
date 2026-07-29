#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

cd "$PROJECT_DIRECTORY"

IMAGE_REFERENCE="${1:-devops-ci-api:local}"
HOST_PORT="${2:-18080}"
CONTAINER_NAME="${3:-devops-ci-api-smoke-test}"
REPORT_FILE="${REPORT_FILE:-reports/container-smoke-test.txt}"

mkdir -p "$(dirname "$REPORT_FILE")"

exec > >(tee "$REPORT_FILE") 2>&1

cleanup() {
  EXIT_CODE=$?

  trap - EXIT

  echo ""
  echo "Container logs"
  echo "=============="

  docker logs "$CONTAINER_NAME" 2>&1 || true

  echo ""
  echo "Container state"
  echo "==============="

  docker inspect \
    -f '
Status={{.State.Status}}
Running={{.State.Running}}
ExitCode={{.State.ExitCode}}
Health={{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}
' \
    "$CONTAINER_NAME" \
    2>/dev/null || true

  docker rm -f "$CONTAINER_NAME" \
    >/dev/null 2>&1 || true

  exit "$EXIT_CODE"
}

trap cleanup EXIT

echo "Docker Container Smoke Test"
echo "==========================="
echo ""
echo "Image:     $IMAGE_REFERENCE"
echo "Container: $CONTAINER_NAME"
echo "Host port: $HOST_PORT"
echo ""

echo "1. Removing old test container"

docker rm -f "$CONTAINER_NAME" \
  >/dev/null 2>&1 || true

echo "2. Starting container"

docker run -d \
  --name "$CONTAINER_NAME" \
  -p "127.0.0.1:${HOST_PORT}:3000" \
  -e APP_ENV=smoke-test \
  "$IMAGE_REFERENCE"

echo ""
echo "3. Waiting for Docker healthcheck"

HEALTHY=false

for ATTEMPT in $(seq 1 20); do
  CONTAINER_STATUS="$(
    docker inspect \
      -f '{{.State.Status}}' \
      "$CONTAINER_NAME"
  )"

  HEALTH_STATUS="$(
    docker inspect \
      -f '{{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}' \
      "$CONTAINER_NAME"
  )"

  echo "Attempt $ATTEMPT/20: container=$CONTAINER_STATUS health=$HEALTH_STATUS"

  if [ "$CONTAINER_STATUS" = "exited" ] ||
     [ "$CONTAINER_STATUS" = "dead" ]; then
    echo "Container stopped before becoming healthy."
    exit 1
  fi

  if [ "$HEALTH_STATUS" = "healthy" ]; then
    HEALTHY=true
    break
  fi

  sleep 2
done

if [ "$HEALTHY" != "true" ]; then
  echo "Container did not become healthy."
  exit 1
fi

BASE_URL="http://127.0.0.1:${HOST_PORT}"

echo ""
echo "4. Testing GET /"

curl \
  --fail \
  --silent \
  --show-error \
  "$BASE_URL"

echo ""
echo ""

echo "5. Testing GET /health"

HEALTH_RESPONSE="$(
  curl \
    --fail \
    --silent \
    --show-error \
    "$BASE_URL/health"
)"

echo "$HEALTH_RESPONSE"

printf '%s\n' "$HEALTH_RESPONSE" |
  grep -q '"status": "ok"'

echo ""
echo "6. Testing GET /version"

VERSION_RESPONSE="$(
  curl \
    --fail \
    --silent \
    --show-error \
    "$BASE_URL/version"
)"

echo "$VERSION_RESPONSE"

printf '%s\n' "$VERSION_RESPONSE" |
  grep -q '"app": "docker-ci-api"'

echo ""
echo "7. Testing expected HTTP 500"

ERROR_STATUS="$(
  curl \
    --silent \
    --output /tmp/docker-ci-api-error.json \
    --write-out "%{http_code}" \
    "$BASE_URL/error"
)"

cat /tmp/docker-ci-api-error.json
echo ""
echo "HTTP status: $ERROR_STATUS"

if [ "$ERROR_STATUS" != "500" ]; then
  echo "Expected HTTP 500 from /error."
  exit 1
fi

echo ""
echo "Container smoke test completed successfully."