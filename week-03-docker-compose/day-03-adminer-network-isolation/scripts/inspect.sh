#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo "Docker Compose Day 03 - Inspect Stack"
echo "====================================="
echo ""

echo "1. Profiles:"
docker compose config --profiles
echo ""

echo "2. Services:"
docker compose --profile tools config --services
echo ""

echo "3. Service status:"
docker compose --profile tools ps
echo ""

echo "4. Images:"
docker compose --profile tools images
echo ""

echo "5. Processes:"
docker compose --profile tools top
echo ""

echo "6. Networks:"
docker network ls | grep devops-compose-day03 || true
echo ""

echo "7. Public network members:"
docker network inspect \
  -f '{{range $id, $container := .Containers}}{{println $container.Name}}{{end}}' \
  devops-compose-day03_public-net
echo ""

echo "8. Private network members:"
docker network inspect \
  -f '{{range $id, $container := .Containers}}{{println $container.Name}}{{end}}' \
  devops-compose-day03_private-net
echo ""

echo "9. PostgreSQL published ports:"
docker inspect \
  -f '{{json .NetworkSettings.Ports}}' \
  "$(docker compose ps -q db)"
echo ""

echo "10. PostgreSQL volume:"
docker volume ls | grep devops-compose-day03 || true
echo ""

echo "11. API database configuration:"
docker compose exec -T api sh -c '
  echo "DB_HOST=$DB_HOST"
  echo "DB_PORT=$DB_PORT"
  echo "DB_NAME=$DB_NAME"
  echo "DB_USER=$DB_USER"
'
echo ""

echo "12. Database readiness:"
docker compose exec -T db sh -c '
  pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB"
'
echo ""

echo "13. Recent API logs:"
docker compose logs --tail 10 api
echo ""

echo "14. Recent database logs:"
docker compose logs --tail 10 db
echo ""

echo "15. Recent Adminer logs:"
docker compose --profile tools logs --tail 10 adminer 2>/dev/null ||
  echo "Adminer is not running."

echo ""
echo "Inspection finished."