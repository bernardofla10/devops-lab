#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

MODE="${1:-dev}"

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
    echo "Usage: ./scripts/inspect.sh dev|prod"
    exit 1
    ;;
esac

echo "Docker Compose Day 05 - Inspect Environment"
echo "==========================================="
echo ""
echo "Environment: $MODE"
echo ""

echo "1. Services:"
docker compose "${COMPOSE_ARGS[@]}" ps
echo ""

API_ID="$(
  docker compose "${COMPOSE_ARGS[@]}" ps -q api
)"

echo "2. API environment:"
docker inspect \
  -f '{{range .Config.Env}}{{println .}}{{end}}' \
  "$API_ID" |
  grep -E 'APP_|NODE_ENV|DB_HOST|DB_PORT'
echo ""

echo "3. API command:"
docker inspect \
  -f '{{json .Config.Cmd}}' \
  "$API_ID"
echo ""

echo "4. API mounts:"
docker inspect \
  -f '{{json .Mounts}}' \
  "$API_ID"
echo ""

echo "5. API ports:"
docker port "$API_ID" || true
echo ""

echo "6. Restart policy:"
docker inspect \
  -f '{{.HostConfig.RestartPolicy.Name}}' \
  "$API_ID"
echo ""

echo "7. Read-only root filesystem:"
docker inspect \
  -f '{{.HostConfig.ReadonlyRootfs}}' \
  "$API_ID"
echo ""

echo "8. Resource limits:"
docker inspect \
  -f '
Memory={{.HostConfig.Memory}}
MemoryReservation={{.HostConfig.MemoryReservation}}
NanoCPUs={{.HostConfig.NanoCpus}}
PidsLimit={{.HostConfig.PidsLimit}}
' \
  "$API_ID"
echo ""

echo "9. Recent API logs:"
docker compose "${COMPOSE_ARGS[@]}" logs --tail 15 api