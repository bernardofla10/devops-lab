#!/usr/bin/env bash

set -euo pipefail

CONTAINER_NAME="${1:-env-app-day04}"
URL="${2:-http://localhost:8084}"

echo "Docker Logs Test"
echo "================"
echo ""

echo "Container: $CONTAINER_NAME"
echo "URL: $URL"
echo ""

echo "1. Generating requests..."
curl -s "$URL" >/dev/null
curl -s "$URL/health" >/dev/null
curl -s "$URL/config" >/dev/null
curl -s "$URL/error" >/dev/null || true
echo "Requests generated."
echo ""

echo "2. Last 20 log lines:"
docker logs --tail 20 "$CONTAINER_NAME"
echo ""

echo "3. Logs with Docker timestamps:"
docker logs -t --tail 10 "$CONTAINER_NAME"
echo ""

echo "4. Searching for simulated errors:"
docker logs "$CONTAINER_NAME" 2>&1 | grep simulated || echo "No simulated error found."
echo ""

echo "Logs test finished."