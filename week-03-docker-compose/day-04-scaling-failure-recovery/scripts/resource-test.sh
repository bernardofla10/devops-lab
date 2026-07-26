#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

if [ -f ".env" ]; then
  set -a
  source .env
  set +a
fi

GATEWAY_HOST_PORT="${GATEWAY_HOST_PORT:-8093}"
BASE_URL="http://localhost:${GATEWAY_HOST_PORT}"
REQUEST_COUNT="${1:-8}"
WORK_MILLISECONDS="${2:-3000}"

echo "Docker Compose Day 04 - Resource Test"
echo "====================================="
echo ""

echo "1. Configured resource limits:"

for CONTAINER_ID in $(docker compose ps -q api); do
  docker inspect \
    -f '
Name={{trimPrefix "/" .Name}}
MemoryBytes={{.HostConfig.Memory}}
MemoryReservationBytes={{.HostConfig.MemoryReservation}}
NanoCPUs={{.HostConfig.NanoCpus}}
PidsLimit={{.HostConfig.PidsLimit}}
' \
    "$CONTAINER_ID"
done

echo ""
echo "2. Resource usage before workload:"
docker stats --no-stream \
  $(docker compose ps -q api)
echo ""

echo "3. Starting $REQUEST_COUNT CPU-work requests..."

for REQUEST_NUMBER in $(seq 1 "$REQUEST_COUNT"); do
  curl -s \
    "$BASE_URL/work?ms=$WORK_MILLISECONDS" \
    >/tmp/day04-work-"$REQUEST_NUMBER".json &
done

echo ""
echo "4. Resource usage during workload:"

for SAMPLE in $(seq 1 5); do
  echo ""
  echo "Sample $SAMPLE/5"

  docker stats --no-stream \
    $(docker compose ps -q api)

  sleep 1
done

wait

echo ""
echo "5. Resource usage after workload:"
docker stats --no-stream \
  $(docker compose ps -q api)
echo ""

echo "Resource test finished."