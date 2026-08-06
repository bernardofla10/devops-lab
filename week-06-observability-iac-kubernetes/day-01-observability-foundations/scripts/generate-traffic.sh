#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

TRAFFIC_REPORT="$REPORT_DIRECTORY/traffic.txt"

: > "$TRAFFIC_REPORT"

request() {
  local URL="$1"

  local RESULT

  RESULT="$(
    curl \
      --silent \
      --output /dev/null \
      --write-out \
        '%{http_code} %{time_total}' \
      "$URL"
  )"

  printf '%-55s %s\n' \
    "$URL" \
    "$RESULT" |
    tee -a "$TRAFFIC_REPORT"
}

echo "Generate Observability Traffic"
echo "=============================="
echo ""

for _ in $(seq 1 10); do
  request "$BASE_URL/"
done

for _ in $(seq 1 5); do
  request "$BASE_URL/health"
done

for DELAY_MS in \
  10 \
  25 \
  50 \
  100 \
  250 \
  500 \
  1000; do

  request \
    "$BASE_URL/work?delayMs=$DELAY_MS"
done

for _ in $(seq 1 3); do
  request "$BASE_URL/error"
done

for _ in $(seq 1 2); do
  request "$BASE_URL/unknown/path"
done

echo ""
echo "Traffic report:"
echo "$TRAFFIC_REPORT"