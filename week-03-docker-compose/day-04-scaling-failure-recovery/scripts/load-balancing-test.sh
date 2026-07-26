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
REQUESTS="${1:-30}"
OUTPUT_FILE="/tmp/day04-api-hostnames.txt"

rm -f "$OUTPUT_FILE"

echo "Docker Compose Day 04 - Load Balancing Test"
echo "==========================================="
echo ""
echo "Base URL: $BASE_URL"
echo "Requests: $REQUESTS"
echo ""

echo "1. Sending requests..."

for REQUEST_NUMBER in $(seq 1 "$REQUESTS"); do
  RESPONSE="$(curl -s "$BASE_URL/instance")"

  HOSTNAME_VALUE="$(
    printf '%s\n' "$RESPONSE" |
      sed -n 's/.*"hostname": "\([^"]*\)".*/\1/p'
  )"

  if [ -z "$HOSTNAME_VALUE" ]; then
    echo "Request $REQUEST_NUMBER failed to return a hostname."
    continue
  fi

  echo "$HOSTNAME_VALUE" >> "$OUTPUT_FILE"

  printf '%02d -> %s\n' \
    "$REQUEST_NUMBER" \
    "$HOSTNAME_VALUE"
done

echo ""
echo "2. Distribution by replica:"

if [ -f "$OUTPUT_FILE" ]; then
  sort "$OUTPUT_FILE" |
    uniq -c |
    sort -nr
fi

echo ""
UNIQUE_REPLICAS="$(
  sort -u "$OUTPUT_FILE" 2>/dev/null |
    wc -l
)"

echo "Unique replicas observed: $UNIQUE_REPLICAS"
echo ""

if [ "$UNIQUE_REPLICAS" -lt 2 ]; then
  echo "Only one replica was observed."
  echo "Restart the gateway and repeat:"
  echo "docker compose restart gateway"
  echo "./scripts/load-balancing-test.sh $REQUESTS"
else
  echo "Multiple API replicas handled requests."
fi