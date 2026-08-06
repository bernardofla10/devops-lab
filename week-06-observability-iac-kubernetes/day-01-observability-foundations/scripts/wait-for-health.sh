#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

echo "Waiting for application health"
echo "=============================="
echo ""

HEALTHY=false

for ATTEMPT in $(seq 1 30); do
  STATUS="$(
    docker inspect \
      --format '{{.State.Status}}' \
      "$CONTAINER_NAME" \
      2>/dev/null \
      || echo missing
  )"

  HEALTH="$(
    docker inspect \
      --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}' \
      "$CONTAINER_NAME" \
      2>/dev/null \
      || echo missing
  )"

  echo \
    "Attempt $ATTEMPT/30: status=$STATUS health=$HEALTH"

  if [ "$STATUS" = "exited" ] ||
     [ "$STATUS" = "dead" ]; then

    echo ""
    docker logs "$CONTAINER_NAME" \
      2>&1 || true

    exit 1
  fi

  if [ "$HEALTH" = "healthy" ]; then
    HEALTHY=true
    break
  fi

  sleep 2
done

if [ "$HEALTHY" != "true" ]; then
  echo ""
  echo "Container did not become healthy."

  docker logs "$CONTAINER_NAME" \
    2>&1 || true

  exit 1
fi

echo ""
echo "Health endpoint:"

curl \
  --fail \
  --silent \
  --show-error \
  "$BASE_URL/health"

echo ""
echo ""
echo "Application is healthy."