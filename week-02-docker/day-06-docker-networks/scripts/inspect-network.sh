#!/usr/bin/env bash

set -euo pipefail

NETWORK_NAME="${1:-devops-net-day06}"
CONTAINER_NAME="${2:-api-day06}"

echo "Docker Network Inspect Report"
echo "============================="
echo ""

echo "1. Docker networks:"
docker network ls
echo ""

echo "2. Inspecting network: $NETWORK_NAME"
if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
  docker network inspect "$NETWORK_NAME"
else
  echo "Network not found: $NETWORK_NAME"
fi
echo ""

echo "3. Inspecting container network settings: $CONTAINER_NAME"
if docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  echo "Container IP addresses:"
  docker inspect -f '{{range $name, $network := .NetworkSettings.Networks}}{{println $name $network.IPAddress}}{{end}}' "$CONTAINER_NAME"
  echo ""
  echo "Published ports:"
  docker port "$CONTAINER_NAME" || true
  echo ""
  echo "Recent logs:"
  docker logs --tail 15 "$CONTAINER_NAME" || true
else
  echo "Container not found: $CONTAINER_NAME"
fi

echo ""
echo "Network inspect finished."