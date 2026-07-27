#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

MODE="${1:-}"
BACKUP_FILE="${2:-}"

if [ -z "$MODE" ] || [ -z "$BACKUP_FILE" ]; then
  echo "Usage:"
  echo "./scripts/restore.sh dev|prod backups/file.sql"
  exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
  echo "Backup file not found:"
  echo "$BACKUP_FILE"
  exit 1
fi

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
    echo "Mode must be dev or prod."
    exit 1
    ;;
esac

echo "PostgreSQL Restore"
echo "=================="
echo ""
echo "Mode: $MODE"
echo "Input: $BACKUP_FILE"
echo ""
echo "This operation replaces the current lab database state."
echo ""

echo "1. Stopping API and gateway..."
docker compose "${COMPOSE_ARGS[@]}" stop gateway api
echo ""

echo "2. Restoring backup..."

cat "$BACKUP_FILE" |
  docker compose "${COMPOSE_ARGS[@]}" \
    exec -T db \
    sh -c '
      export PGPASSWORD="$(cat /run/secrets/db_password)"

      psql \
        -v ON_ERROR_STOP=1 \
        -h 127.0.0.1 \
        -U "$POSTGRES_USER" \
        -d "$POSTGRES_DB"
    '

echo ""
echo "3. Starting API and gateway..."
docker compose "${COMPOSE_ARGS[@]}" up -d api gateway
echo ""

echo "4. Waiting for readiness..."
sleep 8

docker compose "${COMPOSE_ARGS[@]}" ps -a

echo ""
echo "Restore completed successfully."