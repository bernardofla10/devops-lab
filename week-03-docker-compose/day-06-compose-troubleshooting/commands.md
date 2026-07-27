# Day 06 - Docker Compose Troubleshooting

## Validate

```bash
docker compose config -q
docker compose config
docker compose config --services
docker compose config --networks
docker compose config --volumes
docker compose config --variables
```

## Status

```bash
docker compose ps
docker compose ps -a
docker compose ps --status exited
docker compose ps -a --format json
```

## Logs

```bash
docker compose logs --tail 50
docker compose logs --tail 50 db
docker compose logs --tail 50 api
docker compose logs --tail 50 gateway
docker compose logs -f db api gateway
```

## Inspect

```bash
docker inspect "$(docker compose ps -q api)"

docker inspect \
  -f '{{json .State.Health}}' \
  "$(docker compose ps -q api)"
```

## Execute diagnostics

```bash
docker compose exec api sh
docker compose exec db sh
docker compose run --rm --no-deps api sh
```

## Database readiness

```bash
docker compose exec db \
  pg_isready \
    -U "$POSTGRES_USER" \
    -d "$POSTGRES_DB"
```

## Events

```bash
docker compose events --json
```

## Host ports

```bash
docker ps \
  --format 'table {{.Names}}\t{{.Ports}}'

sudo ss -tulpn
```

## Volumes and networks

```bash
docker volume ls
docker network ls

docker volume inspect volume-name
docker network inspect network-name
```

## Healthy stack

```bash
docker compose up \
  -d \
  --build \
  --wait \
  --wait-timeout 60
```

## Helper scripts

```bash
chmod +x scripts/*.sh

./scripts/up.sh
./scripts/diagnose.sh
./scripts/events.sh

./scripts/yaml-error-lab.sh
./scripts/missing-variable-lab.sh
./scripts/port-conflict-lab.sh
./scripts/healthcheck-lab.sh
./scripts/dns-lab.sh
./scripts/credentials-lab.sh
./scripts/stale-volume-lab.sh

./scripts/down.sh
./scripts/down.sh --volumes
```