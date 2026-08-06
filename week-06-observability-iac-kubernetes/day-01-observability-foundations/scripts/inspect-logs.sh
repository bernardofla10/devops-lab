#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

RAW_LOG_REPORT="$REPORT_DIRECTORY/container.log"
REQUEST_LOG_REPORT="$REPORT_DIRECTORY/request-logs.jsonl"
ERROR_LOG_REPORT="$REPORT_DIRECTORY/error-logs.jsonl"

echo "Inspect Structured Logs"
echo "======================="
echo ""

docker logs \
  --since 15m \
  "$CONTAINER_NAME" \
  2>&1 |
  tee "$RAW_LOG_REPORT"

echo ""
echo "1. Request logs"

jq \
  --compact-output \
  'select(
    .message == "request_completed"
  )' \
  "$RAW_LOG_REPORT" \
  > "$REQUEST_LOG_REPORT"

cat "$REQUEST_LOG_REPORT"

echo ""
echo "2. Error logs"

jq \
  --compact-output \
  'select(
    .level == "error"
  )' \
  "$RAW_LOG_REPORT" \
  > "$ERROR_LOG_REPORT"

cat "$ERROR_LOG_REPORT"

REQUEST_COUNT="$(
  wc \
    --lines \
    < "$REQUEST_LOG_REPORT"
)"

ERROR_COUNT="$(
  wc \
    --lines \
    < "$ERROR_LOG_REPORT"
)"

echo ""
echo "Request log entries: $REQUEST_COUNT"
echo "Error log entries:   $ERROR_COUNT"

if [ "$REQUEST_COUNT" -eq 0 ]; then
  echo "No request logs were found."
  exit 1
fi

if [ "$ERROR_COUNT" -eq 0 ]; then
  echo "No error logs were found."
  exit 1
fi

echo ""
echo "3. Request IDs"

jq \
  --raw-output \
  '.requestId' \
  "$REQUEST_LOG_REPORT" |
  head

echo ""
echo "Structured logs validated."