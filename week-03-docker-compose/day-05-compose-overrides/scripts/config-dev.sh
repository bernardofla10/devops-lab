#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

ENV_FILE="env/development.env"
PROJECT_NAME="devops-compose-day05-dev"
OUTPUT_FILE="/tmp/day05-development.yaml"

if [ ! -f "$ENV_FILE" ]; then
  cp env/development.env.example "$ENV_FILE"
fi

echo "Docker Compose Day 05 - Development Configuration"
echo "================================================="
echo ""

docker compose \
  -p "$PROJECT_NAME" \
  --env-file "$ENV_FILE" \
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
  config --services