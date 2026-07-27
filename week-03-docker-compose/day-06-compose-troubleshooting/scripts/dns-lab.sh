#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

PROJECT_NAME="devops-compose-day06-dns"

COMPOSE_ARGS=(
  -p "$PROJECT_NAME"
  -f compose.yaml
  -f broken/compose.bad-db-host.yaml
)

echo "Invalid Service DNS Lab"
echo "======================="
echo ""

docker compose "${COMPOSE_ARGS[@]}" \
  down -v --remove-orphans \
  >/dev/null 2>&1 || true

echo "1. Starting database and API..."
docker compose "${COMPOSE_ARGS[@]}" \
  up -d --build db api

sleep 8

echo ""
echo "2. Service status:"
docker compose "${COMPOSE_ARGS[@]}" ps -a
echo ""

echo "3. API logs:"
docker compose "${COMPOSE_ARGS[@]}" \
  logs --tail 30 api
echo ""

echo "4. Testing DNS from a temporary API container..."

set +e

docker compose "${COMPOSE_ARGS[@]}" \
  run \
  --rm \
  --no-deps \
  api \
  node -e '
    require("dns").lookup(
      process.env.DB_HOST,
      (error, address) => {
        if (error) {
          console.error(error.message);
          process.exit(1);
        }

        console.log(address);
      }
    );
  '

RESULT=$?

set -e

echo ""
echo "5. Cleaning lab..."

docker compose "${COMPOSE_ARGS[@]}" \
  down -v --remove-orphans \
  >/dev/null 2>&1 || true

if [ "$RESULT" -ne 0 ]; then
  echo "Expected DNS failure confirmed."
else
  echo "Unexpected DNS resolution."
  exit 1
fi