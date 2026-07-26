#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo "Docker Compose Day 02 - Inspect Stack"
echo "====================================="
echo ""

echo "1. Declared services:"
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

echo "5. Database readiness:"
docker compose exec -T db sh -c '
  pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB"
'
echo ""

echo "6. Database tables:"
docker compose exec -T db sh -c '
  psql \
    -U "$POSTGRES_USER" \
    -d "$POSTGRES_DB" \
    -c "\dt"
'
echo ""

echo "7. Database item count:"
docker compose exec -T db sh -c '
  psql \
    -U "$POSTGRES_USER" \
    -d "$POSTGRES_DB" \
    -c "SELECT COUNT(*) AS item_count FROM items;"
'
echo ""

echo "8. API database configuration:"
docker compose exec -T api sh -c '
  echo "DB_HOST=$DB_HOST"
  echo "DB_PORT=$DB_PORT"
  echo "DB_NAME=$DB_NAME"
  echo "DB_USER=$DB_USER"
'
echo ""

echo "9. API DNS resolution for db:"
docker compose exec -T api node -e "
require('dns').lookup('db', (error, address) => {
  if (error) {
    console.error(error.message);
    process.exit(1);
  }

  console.log(address);
});
"
echo ""

echo "10. Project network:"
docker network ls | grep devops-compose-day02 || true
echo ""

echo "11. Project volume:"
docker volume ls | grep devops-compose-day02 || true
echo ""

echo "12. Recent database logs:"
docker compose logs --tail 15 db
echo ""

echo "13. Recent API logs:"
docker compose logs --tail 15 api
echo ""

echo "Inspection finished."