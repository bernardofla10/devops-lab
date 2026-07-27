#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

PROJECT_NAME="devops-compose-day06-credentials"

COMPOSE_ARGS=(
  -p "$PROJECT_NAME"
  -f compose.yaml
  -f broken/compose.bad-db-password.yaml
)

echo "Invalid Database Credentials Lab"
echo "================================"
echo ""

docker compose "${COMPOSE_ARGS[@]}" \
  down -v --remove-orphans \
  >/dev/null 2>&1 || true

echo "1. Starting a healthy database..."
docker compose "${COMPOSE_ARGS[@]}" \
  up -d --wait --wait-timeout 30 db

echo "2. Building API image..."
docker compose "${COMPOSE_ARGS[@]}" build api

echo "3. Testing API credentials..."

set +e

docker compose "${COMPOSE_ARGS[@]}" \
  run \
  --rm \
  --no-deps \
  api \
  node -e '
    const { Client } = require("pg");

    const client = new Client({
      host: process.env.DB_HOST,
      port: process.env.DB_PORT,
      database: process.env.DB_NAME,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD
    });

    client.connect()
      .then(() => {
        console.error("Unexpected connection success");
        process.exit(1);
      })
      .catch((error) => {
        console.error(error.message);
        process.exit(2);
      });
  '

RESULT=$?

set -e

echo ""
echo "4. Cleaning lab..."

docker compose "${COMPOSE_ARGS[@]}" \
  down -v --remove-orphans \
  >/dev/null 2>&1 || true

if [ "$RESULT" -eq 2 ]; then
  echo "Expected authentication failure confirmed."
else
  echo "Unexpected result: $RESULT"
  exit 1
fi