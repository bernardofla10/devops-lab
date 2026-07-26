#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo "Docker Compose Day 04 - Stop Scalable Stack"
echo "==========================================="
echo ""

if [ "${1:-}" = "--volumes" ]; then
  echo "Removing services, networks and PostgreSQL volume..."
  docker compose down -v --remove-orphans

  echo ""
  echo "Persistent database data was removed."
else
  echo "Removing services and project networks..."
  docker compose down --remove-orphans

  echo ""
  echo "The PostgreSQL named volume was preserved."
fi

echo ""
echo "Current services:"
docker compose ps -a