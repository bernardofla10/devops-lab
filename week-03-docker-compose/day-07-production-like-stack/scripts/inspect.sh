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
    echo "Usage: ./scripts/inspect.sh dev|prod"
    exit 1
    ;;
esac

echo "Production-like Stack Inspection"
echo "================================"
echo ""
echo "Mode: $MODE"
echo ""

echo "1. Effective services:"
docker compose "${COMPOSE_ARGS[@]}" config --services
echo ""

echo "2. Service status:"
docker compose "${COMPOSE_ARGS[@]}" ps -a
echo ""

echo "3. Migration logs:"
docker compose "${COMPOSE_ARGS[@]}" logs --tail 20 migrate
echo ""

echo "4. Applied migrations:"
docker compose "${COMPOSE_ARGS[@]}" \
  exec -T db \
  sh -c '
    psql \
      -U "$POSTGRES_USER" \
      -d "$POSTGRES_DB" \
      -c "SELECT version, applied_at FROM schema_migrations ORDER BY applied_at;"
  '
echo ""

echo "5. API secret mounts:"
API_ID="$(
  docker compose "${COMPOSE_ARGS[@]}" ps -q api
)"

docker inspect \
  -f '{{range .Mounts}}{{if eq .Destination "/run/secrets/db_password"}}Type={{.Type}} Destination={{.Destination}}{{end}}{{end}}' \
  "$API_ID"
echo ""

echo "6. API networks:"
docker inspect \
  -f '{{range $name, $network := .NetworkSettings.Networks}}{{println $name $network.IPAddress}}{{end}}' \
  "$API_ID"
echo ""

echo "7. Database volume:"
docker volume ls |
  grep devops-compose-day07 ||
  true
echo ""

echo "8. Project networks:"
docker network ls |
  grep devops-compose-day07 ||
  true
echo ""

echo "9. API health:"
docker inspect \
  -f '{{json .State.Health}}' \
  "$API_ID"
echo ""

echo "10. Recent API logs:"
docker compose "${COMPOSE_ARGS[@]}" logs --tail 20 api
echo ""

echo "11. Recent gateway logs:"
docker compose "${COMPOSE_ARGS[@]}" logs --tail 20 gateway