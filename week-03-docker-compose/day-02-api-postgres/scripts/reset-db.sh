#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo "Docker Compose Day 02 - Reset PostgreSQL"
echo "========================================"
echo ""

if [ "${1:-}" != "--confirm" ]; then
  echo "This operation removes the PostgreSQL volume and all lab data."
  echo ""
  echo "Run explicitly:"
  echo "./scripts/reset-db.sh --confirm"
  exit 1
fi

echo "1. Removing containers, network and volumes..."
docker compose down -v
echo ""

echo "2. Starting the stack with a fresh database..."
docker compose up -d --build
echo ""

echo "3. Waiting for initialization..."
sleep 8
echo ""

echo "4. Current services:"
docker compose ps
echo ""

echo "5. Initial database rows:"
docker compose exec -T db sh -c '
  psql \
    -U "$POSTGRES_USER" \
    -d "$POSTGRES_DB" \
    -c "SELECT * FROM items ORDER BY id;"
'

echo ""
echo "Database reset finished."