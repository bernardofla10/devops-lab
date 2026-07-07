#!/usr/bin/env bash

set -euo pipefail

URL="${1:-http://localhost:8080/health}"

echo "Checking Nginx health endpoint..."
echo "URL: $URL"
echo ""

HTTP_STATUS=$(curl -s -o /tmp/nginx-health-check.out -w "%{http_code}" "$URL")

echo "HTTP status: $HTTP_STATUS"
echo "Response body:"
cat /tmp/nginx-health-check.out
echo ""

if [ "$HTTP_STATUS" = "200" ]; then
  echo "Nginx health check passed."
  exit 0
else
  echo "Nginx health check failed."
  exit 1
fi