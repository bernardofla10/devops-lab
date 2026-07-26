#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

REPLICAS="${1:-3}"

if ! [[ "$REPLICAS" =~ ^[1-9][0-9]*$ ]]; then
  echo "Replica count must be a positive integer."
  echo "Example: ./scripts/scale.sh 4"
  exit 1
fi

echo "Docker Compose Day 04 - Scale API"
echo "================================="
echo ""
echo "Target replicas: $REPLICAS"
echo ""

echo "1. Scaling API..."
docker compose up -d --scale "api=$REPLICAS"
echo ""

echo "2. Restarting gateway to refresh upstream addresses..."
docker compose restart gateway
echo ""

echo "3. Waiting for services..."
sleep 5
echo ""

echo "4. Current services:"
docker compose ps
echo ""

echo "5. API replica containers:"
docker compose ps api