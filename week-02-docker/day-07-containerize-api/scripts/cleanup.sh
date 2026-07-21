#!/usr/bin/env bash

set -euo pipefail

CONTAINER_NAME="devops-api-day07"
NETWORK_NAME="devops-api-net-day07"
VOLUME_NAME="devops-api-data-day07"

echo "Final Docker API Cleanup"
echo "========================"
echo ""

echo "1. Removing container..."
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

echo ""
echo "2. Removing network..."
docker network rm "$NETWORK_NAME" >/dev/null 2>&1 || true

echo ""
echo "3. Current containers:"
docker ps -a

echo ""
echo "4. Current networks:"
docker network ls

echo ""
echo "5. Volume still exists if created:"
docker volume ls | grep "$VOLUME_NAME" || echo "Volume not found."

echo ""
echo "Cleanup finished."
echo ""
echo "To remove the persistent volume too, run:"
echo "docker volume rm $VOLUME_NAME"