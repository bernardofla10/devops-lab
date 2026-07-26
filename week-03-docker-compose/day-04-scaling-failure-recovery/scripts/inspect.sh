#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo "Docker Compose Day 04 - Inspect Scalable Stack"
echo "=============================================="
echo ""

echo "1. Services:"
docker compose config --services
echo ""

echo "2. Current status:"
docker compose ps
echo ""

echo "3. API replica count:"
docker compose ps -q api |
  wc -l
echo ""

echo "4. API replica names and states:"

for CONTAINER_ID in $(docker compose ps -q api); do
  docker inspect \
    -f '
Name={{trimPrefix "/" .Name}}
Status={{.State.Status}}
Health={{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}
RestartCount={{.RestartCount}}
RestartPolicy={{.HostConfig.RestartPolicy.Name}}
MaximumRetryCount={{.HostConfig.RestartPolicy.MaximumRetryCount}}
' \
    "$CONTAINER_ID"
done

echo ""
echo "5. API networks and IPs:"

for CONTAINER_ID in $(docker compose ps -q api); do
  docker inspect \
    -f '{{trimPrefix "/" .Name}} -> {{range $name, $network := .NetworkSettings.Networks}}{{println $name $network.IPAddress}}{{end}}' \
    "$CONTAINER_ID"
done

echo ""
echo "6. Resource limits:"

for CONTAINER_ID in $(docker compose ps -q api); do
  docker inspect \
    -f '
Name={{trimPrefix "/" .Name}}
Memory={{.HostConfig.Memory}}
MemoryReservation={{.HostConfig.MemoryReservation}}
NanoCPUs={{.HostConfig.NanoCpus}}
PidsLimit={{.HostConfig.PidsLimit}}
' \
    "$CONTAINER_ID"
done

echo ""
echo "7. Current resource usage:"
docker stats --no-stream \
  $(docker compose ps -q)
echo ""

echo "8. Frontend network:"
docker network inspect \
  -f '{{range $id, $container := .Containers}}{{println $container.Name}}{{end}}' \
  devops-compose-day04_frontend-net
echo ""

echo "9. Backend network:"
docker network inspect \
  -f '{{range $id, $container := .Containers}}{{println $container.Name}}{{end}}' \
  devops-compose-day04_backend-net
echo ""

echo "10. PostgreSQL volume:"
docker volume ls |
  grep devops-compose-day04 ||
  true
echo ""

echo "11. Gateway upstream logs:"
docker compose logs --tail 20 gateway
echo ""

echo "12. Recent API logs:"
docker compose logs --tail 20 api
echo ""

echo "Inspection finished."