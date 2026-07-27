#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

MODE="${1:-dev}"

case "$MODE" in
  dev)
    COMPOSE_ARGS=(
      -p devops-compose-day07-dev
      --env-file env/development.env
    )
    ;;

  prod)
    COMPOSE_ARGS=(
      -p devops-compose-day07-prod
      --env-file env/production.env
      -f compose.yaml
      -f compose.production.yaml
    )
    ;;

  *)
    echo "Usage: ./scripts/backup.sh dev|prod"
    exit 1
    ;;
esac

mkdir -p backups

TIMESTAMP="$(date -u '+%Y%m%dT%H%M%SZ')"
BACKUP_FILE="backups/${MODE}-${TIMESTAMP}.sql"

echo "PostgreSQL Backup"
echo "================="
echo ""
echo "Mode: $MODE"
echo "Output: $BACKUP_FILE"
echo ""

docker compose "${COMPOSE_ARGS[@]}" \
  exec -T db \
  sh -c '
    export PGPASSWORD="$(cat /run/secrets/db_password)"

    pg_dump \
      -h 127.0.0.1 \
      -U "$POSTGRES_USER" \
      -d "$POSTGRES_DB" \
      --clean \
      --if-exists \
      --no-owner \
      --no-privileges
  ' \
  > "$BACKUP_FILE"

if [ ! -s "$BACKUP_FILE" ]; then
  echo "Backup file is empty."
  rm -f "$BACKUP_FILE"
  exit 1
fi

echo "Backup created successfully."
echo ""

ls -lh "$BACKUP_FILE"