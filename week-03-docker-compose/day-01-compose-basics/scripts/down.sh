#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo "Docker Compose Day 01 - Stop Stack"
echo "=================================="
echo ""

if [ "${1:-}" = "--volumes" ]; then
  echo "Removing containers, network and named volumes..."
  docker compose down -v
  echo ""
  echo "Persistent data was removed."
else
  echo "Removing containers and network..."
  docker compose down
  echo ""
  echo "Named volumes were preserved."
fi

echo ""
echo "Current Compose services:"
docker compose ps -a