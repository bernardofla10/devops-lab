#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

METRICS_REPORT="$REPORT_DIRECTORY/metrics.prom"
PROMTOOL_REPORT="$REPORT_DIRECTORY/promtool.txt"

echo "Capture Prometheus Metrics"
echo "=========================="
echo ""

curl \
  --fail \
  --silent \
  --show-error \
  "$BASE_URL/metrics" \
  > "$METRICS_REPORT"

echo "1. Metrics response"

cat "$METRICS_REPORT"

echo ""
echo "2. Validating with promtool"

docker run \
  --rm \
  --interactive \
  --entrypoint=promtool \
  "$PROMETHEUS_IMAGE" \
  check metrics \
  < "$METRICS_REPORT" \
  2>&1 |
  tee "$PROMTOOL_REPORT"

echo ""
echo "3. Required metric families"

REQUIRED_METRICS=(
  observability_app_info
  observability_app_ready
  observability_uptime_seconds
  observability_inflight_requests
  observability_process_resident_memory_bytes
  observability_http_requests_total
  observability_http_request_duration_seconds_bucket
  observability_http_request_duration_seconds_sum
  observability_http_request_duration_seconds_count
)

for METRIC_NAME in "${REQUIRED_METRICS[@]}"; do
  if grep \
    --quiet \
    "^${METRIC_NAME}" \
    "$METRICS_REPORT"; then

    echo "PASS: $METRIC_NAME"
  else
    echo "FAIL: $METRIC_NAME"
    exit 1
  fi
done

echo ""
echo "4. Checking bounded routes"

if grep \
  --quiet \
  'delayMs=' \
  "$METRICS_REPORT"; then

  echo "Query parameters leaked into metric labels."
  exit 1
fi

echo "No query parameters were found in metric labels."

echo ""
echo "Metrics validated successfully."