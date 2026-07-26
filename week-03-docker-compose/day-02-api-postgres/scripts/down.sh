#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo "Docker Compose Day 02 - Stop Stack"
echo "=================================="
echo ""

if [ "${1:-}" = "--volumes" ]; then
  echo "Removing API, PostgreSQL, network and database volume..."
  docker compose down -v

  echo ""
  echo "Persistent database data was removed."
else
  echo "Removing API, PostgreSQL and project network..."
  docker compose down

  echo ""
  echo "The PostgreSQL named volume was preserved."
fi

echo ""
echo "Current services:"
docker compose ps -a