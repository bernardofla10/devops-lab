#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

MODE="${1:-dev}"

case "$MODE" in
  dev)
    ENV_FILE="env/development.env"
    PORT_DEFAULT="8095"
    ;;

  prod)
    ENV_FILE="env/production.env"
    PORT_DEFAULT="8097"
    ;;

  *)
    echo "Usage: ./scripts/test.sh dev|prod"
    exit 1
    ;;
esac

set -a
source "$ENV_FILE"
set +a

BASE_URL="http://${GATEWAY_BIND_IP:-127.0.0.1}:${GATEWAY_HOST_PORT:-$PORT_DEFAULT}"

echo "Docker Compose Day 05 - Environment Tests"
echo "========================================="
echo ""
echo "Environment: $MODE"
echo "Base URL: $BASE_URL"
echo ""

echo "1. Health"
curl -s "$BASE_URL/health"
echo ""
echo ""

echo "2. Configuration"
curl -s "$BASE_URL/config"
echo ""
echo ""

echo "3. Instance"
curl -s "$BASE_URL/instance"
echo ""
echo ""

echo "4. Add item"
curl -s "$BASE_URL/items/add?title=day05-${MODE}-item"
echo ""
echo ""

echo "5. Read items"
curl -s "$BASE_URL/items"
echo ""
echo ""

echo "Tests finished."