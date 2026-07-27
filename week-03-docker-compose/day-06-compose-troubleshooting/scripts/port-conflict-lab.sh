#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

BLOCKER_NAME="day06-port-blocker"

echo "Host Port Conflict Lab"
echo "======================"
echo ""

docker compose down --remove-orphans >/dev/null 2>&1 || true
docker rm -f "$BLOCKER_NAME" >/dev/null 2>&1 || true

echo "1. Occupying host port 8098..."

docker run -d \
  --name "$BLOCKER_NAME" \
  -p 127.0.0.1:8098:80 \
  nginx:alpine

echo ""
echo "2. Trying to start the Compose stack..."

set +e

docker compose up -d --build

RESULT=$?

set -e

echo ""
echo "Compose exit code: $RESULT"
echo ""

echo "3. Compose containers:"
docker compose ps -a || true
echo ""

echo "4. Container using port 8098:"
docker ps \
  --format 'table {{.Names}}\t{{.Ports}}' |
  grep 8098 || true

echo ""
echo "5. Cleaning lab..."

docker compose down -v --remove-orphans >/dev/null 2>&1 || true
docker rm -f "$BLOCKER_NAME" >/dev/null 2>&1 || true

if [ "$RESULT" -ne 0 ]; then
  echo "Expected port-binding failure confirmed."
else
  echo "The stack unexpectedly started."
  exit 1
fi