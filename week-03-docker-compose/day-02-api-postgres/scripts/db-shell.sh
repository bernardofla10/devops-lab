#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

if [ -f ".env" ]; then
  set -a
  source .env
  set +a
fi

POSTGRES_USER="${POSTGRES_USER:-devops}"
POSTGRES_DB="${POSTGRES_DB:-devopsdb}"

echo "Opening PostgreSQL shell"
echo "========================"
echo ""
echo "Database: $POSTGRES_DB"
echo "User: $POSTGRES_USER"
echo ""
echo "Exit psql with: \\q"
echo ""

docker compose exec db \
  psql \
    -U "$POSTGRES_USER" \
    -d "$POSTGRES_DB"