#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

ENV_FILE="env/production.env"
PROJECT_NAME="devops-compose-day05-prod"

COMPOSE_ARGS=(
  -p "$PROJECT_NAME"
  --env-file "$ENV_FILE"
  -f compose.yaml
  -f compose.production.yaml
)

echo "Docker Compose Day 05 - Redeploy Production API"
echo "==============================================="
echo ""

echo "1. Building API image..."
docker compose "${COMPOSE_ARGS[@]}" build api
echo ""

echo "2. Recreating only the API..."
docker compose "${COMPOSE_ARGS[@]}" up --no-deps -d api
echo ""

echo "3. Restarting gateway..."
docker compose "${COMPOSE_ARGS[@]}" restart gateway
echo ""

echo "4. Current services:"
docker compose "${COMPOSE_ARGS[@]}" ps