#!/usr/bin/env bash

set -euo pipefail

CONTAINER_NAME="${1:-devops-api-day07}"

echo "Final Docker API Inspect Report"
echo "==============================="
echo ""

if ! docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  echo "Container not found: $CONTAINER_NAME"
  exit 1
fi

echo "Container: $CONTAINER_NAME"
echo ""

echo "1. Status:"
docker inspect -f '{{.State.Status}}' "$CONTAINER_NAME"
echo ""

echo "2. Health:"
docker inspect -f '{{if .State.Health}}{{.State.Health.Status}}{{else}}no healthcheck{{end}}' "$CONTAINER_NAME"
echo ""

echo "3. Image:"
docker inspect -f '{{.Config.Image}}' "$CONTAINER_NAME"
echo ""

echo "4. Published ports:"
docker port "$CONTAINER_NAME" || true
echo ""

echo "5. Environment variables:"
docker inspect -f '{{range .Config.Env}}{{println .}}{{end}}' "$CONTAINER_NAME"
echo ""

echo "6. Mounts:"
docker inspect -f '{{json .Mounts}}' "$CONTAINER_NAME"
echo ""

echo "7. Networks and IPs:"
docker inspect -f '{{range $name, $network := .NetworkSettings.Networks}}{{println $name $network.IPAddress}}{{end}}' "$CONTAINER_NAME"
echo ""

echo "8. Processes:"
docker top "$CONTAINER_NAME" || true
echo ""

echo "9. Stats:"
docker stats --no-stream "$CONTAINER_NAME" || true
echo ""

echo "10. Recent logs:"
docker logs --tail 15 "$CONTAINER_NAME" || true

echo ""
echo "Inspect finished."