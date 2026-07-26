#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

PROJECT_NAME="devops-compose-day04-conflict"

echo "Docker Compose Day 04 - Port Conflict Lab"
echo "========================================="
echo ""

echo "This lab intentionally tries to publish the same host port"
echo "from two API replicas."
echo ""

set +e

docker compose \
  -p "$PROJECT_NAME" \
  -f compose.yaml \
  -f compose.port-conflict.yaml \
  up \
  -d \
  --build \
  --scale api=2 \
  api

RESULT=$?

set -e

echo ""
echo "Compose exit code: $RESULT"
echo ""

echo "Container status:"
docker compose \
  -p "$PROJECT_NAME" \
  -f compose.yaml \
  -f compose.port-conflict.yaml \
  ps -a

echo ""

if [ "$RESULT" -ne 0 ]; then
  echo "Expected result: scaling failed because both replicas"
  echo "tried to bind host port 8094."
else
  echo "The command unexpectedly succeeded."
  echo "Inspect the published ports and container status manually."
fi

echo ""
echo "Cleaning isolated conflict project..."

docker compose \
  -p "$PROJECT_NAME" \
  -f compose.yaml \
  -f compose.port-conflict.yaml \
  down \
  -v \
  --remove-orphans \
  >/dev/null 2>&1 || true

echo ""
echo "Port conflict lab finished."