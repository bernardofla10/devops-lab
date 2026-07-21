#!/usr/bin/env bash

set -euo pipefail

URL="${1:-http://localhost:8088}"

echo "Testing final Docker API"
echo "========================"
echo ""

echo "Base URL: $URL"
echo ""

echo "1. GET /"
curl -s "$URL"
echo ""
echo ""

echo "2. GET /health"
HEALTH_STATUS=$(curl -s -o /tmp/devops-api-health.out -w "%{http_code}" "$URL/health")
cat /tmp/devops-api-health.out
echo ""
echo "HTTP status: $HEALTH_STATUS"
echo ""

if [ "$HEALTH_STATUS" != "200" ]; then
  echo "Health check failed."
  exit 1
fi

echo "3. GET /config"
curl -s "$URL/config"
echo ""
echo ""

echo "4. Add items"
curl -s "$URL/items/add?title=script-test-item-1"
echo ""
curl -s "$URL/items/add?title=script-test-item-2"
echo ""
echo ""

echo "5. GET /items"
curl -s "$URL/items"
echo ""
echo ""

echo "6. Trigger simulated error"
curl -s -o /tmp/devops-api-error.out -w "%{http_code}" "$URL/error" || true
cat /tmp/devops-api-error.out
echo ""
echo ""

echo "API test finished successfully."