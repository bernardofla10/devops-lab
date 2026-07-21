#!/usr/bin/env bash

set -euo pipefail

CONTAINER_NAME="${1:-devops-api-day07}"

echo "Final Docker API Logs"
echo "====================="
echo ""

echo "Container: $CONTAINER_NAME"
echo ""

echo "1. Last 30 log lines:"
docker logs --tail 30 "$CONTAINER_NAME"
echo ""

echo "2. Logs with timestamps:"
docker logs -t --tail 20 "$CONTAINER_NAME"
echo ""

echo "3. Searching for simulated errors:"
docker logs "$CONTAINER_NAME" 2>&1 | grep simulated || echo "No simulated errors found."
echo ""

echo "Logs check finished."