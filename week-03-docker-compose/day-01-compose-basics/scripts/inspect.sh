#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo "Docker Compose Day 01 - Inspect Stack"
echo "====================================="
echo ""

echo "1. Resolved services:"
docker compose config --services
echo ""

echo "2. Service status:"
docker compose ps
echo ""

echo "3. Images:"
docker compose images
echo ""

echo "4. Processes:"
docker compose top
echo ""

echo "5. API environment:"
docker compose exec -T api sh -c '
  printenv APP_NAME
  printenv APP_ENV
  printenv PORT
  printenv DATA_DIR
'
echo ""

echo "6. Persistent data:"
docker compose exec -T api sh -c '
  ls -la /data
  cat /data/items.json
'
echo ""

echo "7. Project networks:"
docker network ls | grep devops-compose-day01 || true
echo ""

echo "8. Project volumes:"
docker volume ls | grep devops-compose-day01 || true
echo ""

echo "9. Recent API logs:"
docker compose logs --tail 20 api
echo ""

echo "Inspection finished."