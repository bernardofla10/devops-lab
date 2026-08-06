#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

echo "Verify Observability Foundations"
echo "================================"
echo ""

echo "1. Waiting for healthy container"

"$PROJECT_DIRECTORY/scripts/wait-for-health.sh"

echo ""
echo "2. Verifying liveness"

LIVE_STATUS="$(
  curl \
    --silent \
    --output "$REPORT_DIRECTORY/live.json" \
    --write-out "%{http_code}" \
    "$BASE_URL/live"
)"

echo "HTTP: $LIVE_STATUS"

[ "$LIVE_STATUS" = "200" ]

jq -e \
  '.status == "alive"' \
  "$REPORT_DIRECTORY/live.json" \
  >/dev/null

echo ""
echo "3. Verifying readiness"

READY_STATUS="$(
  curl \
    --silent \
    --output "$REPORT_DIRECTORY/ready.json" \
    --write-out "%{http_code}" \
    "$BASE_URL/ready"
)"

echo "HTTP: $READY_STATUS"

[ "$READY_STATUS" = "200" ]

jq -e \
  '.status == "ready"' \
  "$REPORT_DIRECTORY/ready.json" \
  >/dev/null

echo ""
echo "4. Verifying aggregate health"

HEALTH_STATUS="$(
  curl \
    --silent \
    --output "$REPORT_DIRECTORY/health.json" \
    --write-out "%{http_code}" \
    "$BASE_URL/health"
)"

echo "HTTP: $HEALTH_STATUS"

[ "$HEALTH_STATUS" = "200" ]

jq -e '
  .status == "ok"
  and
  .checks.live == true
  and
  .checks.ready == true
' \
  "$REPORT_DIRECTORY/health.json" \
  >/dev/null

echo ""
echo "5. Generating traffic"

"$PROJECT_DIRECTORY/scripts/generate-traffic.sh"

echo ""
echo "6. Capturing metrics"

"$PROJECT_DIRECTORY/scripts/capture-metrics.sh"

echo ""
echo "7. Inspecting logs"

"$PROJECT_DIRECTORY/scripts/inspect-logs.sh"

echo ""
echo "8. Container state"

docker inspect \
  --format '
Name={{.Name}}
Status={{.State.Status}}
Health={{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}
RestartCount={{.RestartCount}}
StartedAt={{.State.StartedAt}}
LoggingDriver={{.HostConfig.LogConfig.Type}}
PortBindings={{json .HostConfig.PortBindings}}
' \
  "$CONTAINER_NAME" |
  tee "$REPORT_DIRECTORY/container-state.txt"

echo ""
echo "Observability verification completed."