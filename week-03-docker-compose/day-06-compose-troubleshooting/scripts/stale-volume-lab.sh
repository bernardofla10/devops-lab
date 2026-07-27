#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

PROJECT_NAME="devops-compose-day06-stale"
INITIAL_ENV="env/stale-initial.env.example"
CHANGED_ENV="env/stale-changed.env.example"

echo "Stale PostgreSQL Volume Lab"
echo "==========================="
echo ""

docker compose \
  -p "$PROJECT_NAME" \
  --env-file "$INITIAL_ENV" \
  down -v --remove-orphans \
  >/dev/null 2>&1 || true

echo "1. Initializing database with the first password..."

docker compose \
  -p "$PROJECT_NAME" \
  --env-file "$INITIAL_ENV" \
  up -d --wait --wait-timeout 30 db

echo ""
echo "2. Removing container while preserving volume..."

docker compose \
  -p "$PROJECT_NAME" \
  --env-file "$INITIAL_ENV" \
  down

echo ""
echo "3. Recreating database container with a changed variable..."

docker compose \
  -p "$PROJECT_NAME" \
  --env-file "$CHANGED_ENV" \
  up -d --wait --wait-timeout 30 db

echo ""
echo "4. Building API..."

docker compose \
  -p "$PROJECT_NAME" \
  --env-file "$CHANGED_ENV" \
  build api

echo ""
echo "5. Trying to connect using the changed password..."

set +e

docker compose \
  -p "$PROJECT_NAME" \
  --env-file "$CHANGED_ENV" \
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
echo "6. Removing stale volume..."

docker compose \
  -p "$PROJECT_NAME" \
  --env-file "$CHANGED_ENV" \
  down -v --remove-orphans \
  >/dev/null 2>&1 || true

if [ "$RESULT" -eq 2 ]; then
  echo "Expected stale-volume credential failure confirmed."
  echo "POSTGRES_PASSWORD did not modify the initialized database."
else
  echo "Unexpected result: $RESULT"
  exit 1
fi