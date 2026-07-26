#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

MODE="${1:-dev}"
REMOVE_VOLUMES="${2:-}"

case "$MODE" in
  dev)
    ENV_FILE="env/development.env"
    PROJECT_NAME="devops-compose-day05-dev"

    COMPOSE_ARGS=(
      -p "$PROJECT_NAME"
      --env-file "$ENV_FILE"
    )
    ;;

  prod)
    ENV_FILE="env/production.env"
    PROJECT_NAME="devops-compose-day05-prod"

    COMPOSE_ARGS=(
      -p "$PROJECT_NAME"
      --env-file "$ENV_FILE"
      -f compose.yaml
      -f compose.production.yaml
    )
    ;;

  *)
    echo "Usage: ./scripts/down.sh dev|prod [--volumes]"
    exit 1
    ;;
esac

echo "Docker Compose Day 05 - Stop Environment"
echo "========================================"
echo ""
echo "Environment: $MODE"
echo ""

if [ "$REMOVE_VOLUMES" = "--volumes" ]; then
  docker compose "${COMPOSE_ARGS[@]}" down -v --remove-orphans
  echo "Containers, networks and volumes removed."
else
  docker compose "${COMPOSE_ARGS[@]}" down --remove-orphans
  echo "Containers and networks removed. Volumes preserved."
fi