#!/usr/bin/env bash

set -euo pipefail

HEALTH_URL="${HEALTH_URL:-http://localhost:8080/health}"

echo "Nginx Operations Check"
echo "======================"
echo ""

echo "1. Checking Nginx service status..."
if systemctl is-active --quiet nginx; then
  echo "Nginx is active."
else
  echo "Nginx is not active."
fi

echo ""
echo "2. Testing Nginx configuration..."
if sudo nginx -t; then
  echo "Nginx configuration is valid."
else
  echo "Nginx configuration is invalid."
  exit 1
fi

echo ""
echo "3. Checking listening ports..."
sudo ss -tulpn | grep nginx || echo "No Nginx listening ports found."

echo ""
echo "4. Checking health endpoint..."
echo "URL: $HEALTH_URL"

HTTP_STATUS=$(curl -s -o /tmp/nginx-ops-check.out -w "%{http_code}" "$HEALTH_URL" || true)

echo "HTTP status: $HTTP_STATUS"
echo "Response body:"
cat /tmp/nginx-ops-check.out 2>/dev/null || true
echo ""

if [ "$HTTP_STATUS" = "200" ]; then
  echo "Health endpoint is OK."
else
  echo "Health endpoint failed."
fi

echo ""
echo "5. Recent Nginx logs from systemd:"
journalctl -u nginx -n 10 --no-pager || true

echo ""
echo "Nginx operations check finished."