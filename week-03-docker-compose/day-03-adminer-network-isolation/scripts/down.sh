#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo "Docker Compose Day 03 - Stop Stack"
echo "=================================="
echo ""

if [ "${1:-}" = "--volumes" ]; then
  echo "Removing services, networks and PostgreSQL volume..."
  docker compose --profile tools down -v

  echo ""
  echo "Persistent database data was removed."
else
  echo "Removing services and project networks..."
  docker compose --profile tools down

  echo ""
  echo "The PostgreSQL volume was preserved."
fi

echo ""
echo "Current services:"
docker compose --profile tools ps -a