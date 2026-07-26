#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

ENV_FILE="env/production.env"
PROJECT_NAME="devops-compose-day05-prod"
OUTPUT_FILE="/tmp/day05-production.yaml"

if [ ! -f "$ENV_FILE" ]; then
  cp env/production.env.example "$ENV_FILE"
fi

echo "Docker Compose Day 05 - Production Configuration"
echo "================================================"
echo ""

docker compose \
  -p "$PROJECT_NAME" \
  --env-file "$ENV_FILE" \
  -f compose.yaml \
  -f compose.production.yaml \
  config \
  > "$OUTPUT_FILE"

echo "Configuration is valid."
echo ""
echo "Resolved configuration:"
echo "$OUTPUT_FILE"
echo ""

docker compose \
  -p "$PROJECT_NAME" \
  --env-file "$ENV_FILE" \
  -f compose.yaml \
  -f compose.production.yaml \
  config --services