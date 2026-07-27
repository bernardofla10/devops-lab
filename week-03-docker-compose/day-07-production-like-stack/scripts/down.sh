#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

MODE="${1:-dev}"
REMOVE_VOLUMES="${2:-}"

case "$MODE" in
  dev)
    COMPOSE_ARGS=(
      -p devops-compose-day07-dev
      --env-file env/development.env
      --profile tools
      --profile test
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
    echo "Usage: ./scripts/down.sh dev|prod [--volumes]"
    exit 1
    ;;
esac

echo "Stopping production-like stack"
echo "=============================="
echo ""
echo "Mode: $MODE"
echo ""

if [ "$REMOVE_VOLUMES" = "--volumes" ]; then
  docker compose "${COMPOSE_ARGS[@]}" \
    down -v --remove-orphans

  echo "Containers, networks and database volume removed."
else
  docker compose "${COMPOSE_ARGS[@]}" \
    down --remove-orphans

  echo "Containers and networks removed."
  echo "Database volume preserved."
fi