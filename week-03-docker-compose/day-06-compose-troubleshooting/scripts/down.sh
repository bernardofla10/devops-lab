#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo "Docker Compose Day 06 - Stop Stack"
echo "=================================="
echo ""

if [ "${1:-}" = "--volumes" ]; then
  docker compose down -v --remove-orphans
  echo "Containers, networks and volume removed."
else
  docker compose down --remove-orphans
  echo "Containers and networks removed. Volume preserved."
fi