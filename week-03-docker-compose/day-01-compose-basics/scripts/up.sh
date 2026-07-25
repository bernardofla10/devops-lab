#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo "Docker Compose Day 01 - Start Stack"
echo "==================================="
echo ""

if [ ! -f ".env" ]; then
  echo ".env not found. Creating it from .env.example..."
  cp .env.example .env
fi

echo "1. Validating Compose configuration..."
docker compose config >/dev/null
echo "Compose configuration is valid."
echo ""

echo "2. Building and starting services..."
docker compose up -d --build
echo ""

echo "3. Waiting for the API..."
sleep 3
echo ""

echo "4. Current services:"
docker compose ps
echo ""

echo "5. API URL:"
echo "http://localhost:$(grep '^HOST_PORT=' .env | cut -d= -f2 || echo 8089)"