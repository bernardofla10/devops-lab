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
    echo "Usage: ./scripts/test.sh dev|prod"
    exit 1
    ;;
esac

echo "Running integration tests"
echo "========================="
echo ""
echo "Mode: $MODE"
echo ""

docker compose "${COMPOSE_ARGS[@]}" \
  run --rm test