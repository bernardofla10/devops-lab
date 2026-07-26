# Day 04 - Scaling, Restart Policies and Failure Recovery

## Prepare environment

```bash
cp .env.example .env
```

## Validate

```bash
docker compose config -q
docker compose config --services
docker compose config --networks
docker compose config --volumes
```

## Start with three API replicas

```bash
docker compose up -d --build --scale api=3
docker compose restart gateway
docker compose ps
```

## Test gateway

```bash
curl http://localhost:8093/gateway-health
curl http://localhost:8093/health
curl http://localhost:8093/instance
```

## Scale API

```bash
docker compose up -d --scale api=2
docker compose restart gateway

docker compose up -d --scale api=4
docker compose restart gateway

docker compose up -d --scale api=3
docker compose restart gateway
```

## List replicas

```bash
docker compose ps api
docker compose ps -q api

for id in $(docker compose ps -q api); do
  docker inspect -f '{{trimPrefix "/" .Name}}' "$id"
done
```

## Test multiple replicas

```bash
for i in $(seq 1 20); do
  curl -s http://localhost:8093/instance
  echo
done
```

## Add items concurrently

```bash
for i in $(seq 1 10); do
  curl -s \
    "http://localhost:8093/items/add?title=scaled-item-$i" &
done

wait

curl http://localhost:8093/items
```

## Logs

```bash
docker compose logs api
docker compose logs --tail 20 api
docker compose logs -f api gateway
```

## Kill one replica

```bash
TARGET_ID="$(docker compose ps -q api | head -n 1)"

docker inspect -f '{{.RestartCount}}' "$TARGET_ID"
docker kill "$TARGET_ID"

sleep 5

docker inspect -f '{{.RestartCount}}' "$TARGET_ID"
docker compose ps
```

## Trigger application crash

```bash
curl http://localhost:8093/crash
sleep 3
docker compose ps
docker compose logs --tail 50 api
```

## Restart database dependency

```bash
docker compose restart db
sleep 8
docker compose ps
curl http://localhost:8093/health
```

## Inspect resource limits

```bash
for id in $(docker compose ps -q api); do
  docker inspect \
    -f '
Name={{trimPrefix "/" .Name}}
Memory={{.HostConfig.Memory}}
NanoCPUs={{.HostConfig.NanoCpus}}
PidsLimit={{.HostConfig.PidsLimit}}
' \
    "$id"
done
```

## Observe resource usage

```bash
docker stats
docker stats --no-stream $(docker compose ps -q api)
```

## Generate CPU workload

```bash
for i in $(seq 1 8); do
  curl -s \
    "http://localhost:8093/work?ms=3000" \
    >/dev/null &
done

wait
```

## Helper scripts

```bash
chmod +x scripts/*.sh

./scripts/up.sh
./scripts/scale.sh 2
./scripts/scale.sh 4
./scripts/load-balancing-test.sh 30
./scripts/failure-recovery-lab.sh
./scripts/resource-test.sh
./scripts/inspect.sh
./scripts/port-conflict-lab.sh
./scripts/down.sh
./scripts/down.sh --volumes
```