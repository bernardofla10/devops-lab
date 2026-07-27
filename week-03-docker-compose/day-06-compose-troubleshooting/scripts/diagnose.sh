#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo "Docker Compose Diagnostic Report"
echo "================================"
echo ""

echo "1. Configuration validation:"
if docker compose config -q; then
  echo "Compose configuration is valid."
else
  echo "Compose configuration is invalid."
fi
echo ""

echo "2. Declared services:"
docker compose config --services || true
echo ""

echo "3. Containers, including stopped containers:"
docker compose ps -a || true
echo ""

echo "4. Container states:"

for SERVICE in db api gateway; do
  CONTAINER_ID="$(docker compose ps -q "$SERVICE" 2>/dev/null || true)"

  if [ -z "$CONTAINER_ID" ]; then
    echo "$SERVICE: container not created"
    continue
  fi

  echo ""
  echo "Service: $SERVICE"

  docker inspect \
    -f '
Name={{trimPrefix "/" .Name}}
Status={{.State.Status}}
Running={{.State.Running}}
ExitCode={{.State.ExitCode}}
Error={{.State.Error}}
Health={{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}
RestartCount={{.RestartCount}}
' \
    "$CONTAINER_ID"
done

echo ""
echo "5. Networks:"
docker network ls | grep devops-compose-day06 || true
echo ""

echo "6. Volumes:"
docker volume ls | grep devops-compose-day06 || true
echo ""

echo "7. Recent database logs:"
docker compose logs --tail 20 db 2>/dev/null || true
echo ""

echo "8. Recent API logs:"
docker compose logs --tail 20 api 2>/dev/null || true
echo ""

echo "9. Recent gateway logs:"
docker compose logs --tail 20 gateway 2>/dev/null || true
echo ""

echo "Diagnostic report finished."