#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

if [ ! -f ".env" ]; then
  cp .env.example .env
fi

set -a
source .env
set +a

BASE_URL="http://127.0.0.1:${GATEWAY_HOST_PORT:-8098}"

echo "Docker Compose Day 06 - Start Healthy Stack"
echo "==========================================="
echo ""

echo "1. Validating configuration..."
docker compose config -q
echo "Configuration is valid."
echo ""

echo "2. Building and starting services..."
docker compose up \
  -d \
  --build \
  --wait \
  --wait-timeout 60
echo ""

echo "3. Service status:"
docker compose ps
echo ""

echo "4. Health endpoint:"
curl -s "$BASE_URL/health"
echo ""
echo ""

echo "Stack started successfully:"
echo "$BASE_URL"