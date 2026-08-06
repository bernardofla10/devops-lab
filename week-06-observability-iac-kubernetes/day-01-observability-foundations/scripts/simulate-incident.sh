#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

INCIDENT_REPORT="$REPORT_DIRECTORY/incident.txt"

exec > >(
  tee "$INCIDENT_REPORT"
) 2>&1

echo "Observability Incident Exercise"
echo "==============================="
echo ""

echo "1. Confirming healthy baseline"

"$PROJECT_DIRECTORY/scripts/wait-for-health.sh"

BASELINE_RESTART_COUNT="$(
  docker inspect \
    --format '{{.RestartCount}}' \
    "$CONTAINER_NAME"
)"

echo "Baseline restart count:"
echo "$BASELINE_RESTART_COUNT"

echo ""
echo "2. Producing an application error"

ERROR_STATUS="$(
  curl \
    --silent \
    --output /tmp/observability-error.json \
    --write-out "%{http_code}" \
    "$BASE_URL/error"
)"

cat /tmp/observability-error.json
echo ""
echo "HTTP status: $ERROR_STATUS"

if [ "$ERROR_STATUS" != "500" ]; then
  echo "Expected HTTP 500."
  exit 1
fi

echo ""
echo "3. Confirming container remains healthy"

HEALTH_AFTER_HTTP_ERROR="$(
  docker inspect \
    --format '{{.State.Health.Status}}' \
    "$CONTAINER_NAME"
)"

echo "Health: $HEALTH_AFTER_HTTP_ERROR"

if [
  "$HEALTH_AFTER_HTTP_ERROR" !=
  "healthy"
]; then
  echo "HTTP application error unexpectedly affected container health."
  exit 1
fi

echo ""
echo "4. Simulating process crash"

sleep 12

docker kill \
  --signal SIGKILL \
  "$CONTAINER_NAME"

echo ""
echo "5. Waiting for restart policy recovery"

RECOVERED=false

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

  RESTART_COUNT="$(
    docker inspect \
      --format '{{.RestartCount}}' \
      "$CONTAINER_NAME" \
      2>/dev/null \
      || echo 0
  )"

  echo \
    "Attempt $ATTEMPT/30: status=$STATUS health=$HEALTH restarts=$RESTART_COUNT"

  if [
    "$STATUS" = "running"
  ] &&
     [
       "$HEALTH" = "healthy"
     ] &&
     [
       "$RESTART_COUNT" -gt
       "$BASELINE_RESTART_COUNT"
     ]; then

    RECOVERED=true
    break
  fi

  sleep 2
done

if [ "$RECOVERED" != "true" ]; then
  echo "Container did not recover."
  exit 1
fi

echo ""
echo "6. Verifying service after recovery"

curl \
  --fail \
  --silent \
  --show-error \
  "$BASE_URL/health"

echo ""
echo ""
echo "7. Inspecting restart evidence"

docker inspect \
  --format '
Status={{.State.Status}}
Health={{.State.Health.Status}}
RestartCount={{.RestartCount}}
StartedAt={{.State.StartedAt}}
' \
  "$CONTAINER_NAME"

echo ""
echo "8. Recent logs"

docker logs \
  --tail 30 \
  "$CONTAINER_NAME" \
  2>&1

echo ""
echo "Incident simulation completed."