#!/usr/bin/env bash

set -euo pipefail

echo "Docker Volumes Lab Cleanup"
echo "=========================="
echo ""

echo "Removing lab containers..."
docker rm -f volumes-ephemeral >/dev/null 2>&1 || true
docker rm -f volumes-named >/dev/null 2>&1 || true
docker rm -f volumes-bind >/dev/null 2>&1 || true

echo ""
echo "Containers:"
docker ps -a

echo ""
echo "Volumes:"
docker volume ls | grep devops-data-day05 || echo "No devops-data-day05 volume found."

echo ""
echo "Host bind mount data directory:"
if [ -d "host-data" ]; then
  ls -la host-data
else
  echo "host-data directory not found."
fi

echo ""
echo "Cleanup finished."
echo ""
echo "To remove the named volume too, run:"
echo "docker volume rm devops-data-day05"
echo ""
echo "To remove host bind mount data, run:"
echo "rm -rf host-data"