# Day 03 - Adminer and Compose Network Isolation

## Prepare environment

```bash
cp .env.example .env
```

## Validate configuration

```bash
docker compose --profile tools config -q
docker compose config --profiles
docker compose --profile tools config --services
docker compose --profile tools config --networks
docker compose --profile tools config --volumes
```

## Start core services

```bash
docker compose up -d --build
docker compose ps
```

## Start Adminer profile

```bash
docker compose --profile tools up -d
docker compose --profile tools ps
```

## Test API

```bash
curl http://localhost:8091
curl http://localhost:8091/health
curl http://localhost:8091/db-info
curl http://localhost:8091/items
curl "http://localhost:8091/items/add?title=day03-item"
```

## Test Adminer

```bash
curl -I http://localhost:8092
```

## Adminer login

```text
System: PostgreSQL
Server: db
Username: devops
Password: value from .env
Database: devopsdb
```

## Inspect networks

```bash
docker network ls | grep devops-compose-day03

docker network inspect devops-compose-day03_public-net
docker network inspect devops-compose-day03_private-net
```

## Inspect container network membership

```bash
docker inspect \
  -f '{{range $name, $network := .NetworkSettings.Networks}}{{println $name $network.IPAddress}}{{end}}' \
  "$(docker compose ps -q api)"

docker inspect \
  -f '{{range $name, $network := .NetworkSettings.Networks}}{{println $name $network.IPAddress}}{{end}}' \
  "$(docker compose ps -q db)"

docker inspect \
  -f '{{range $name, $network := .NetworkSettings.Networks}}{{println $name $network.IPAddress}}{{end}}' \
  "$(docker compose --profile tools ps -q adminer)"
```

## Confirm PostgreSQL is not published

```bash
docker compose port db 5432

docker inspect \
  -f '{{json .NetworkSettings.Ports}}' \
  "$(docker compose ps -q db)"
```

## Logs

```bash
docker compose logs --tail 30 api
docker compose logs --tail 30 db
docker compose --profile tools logs --tail 30 adminer
docker compose --profile tools logs -f api db adminer
```

## Profile lifecycle

```bash
docker compose --profile tools stop adminer
docker compose --profile tools start adminer
docker compose --profile tools up -d adminer
```

## Helper scripts

```bash
chmod +x scripts/*.sh

./scripts/up.sh
./scripts/up.sh --core
./scripts/test.sh
./scripts/inspect.sh
./scripts/network-test.sh
./scripts/db-shell.sh
./scripts/down.sh
./scripts/down.sh --volumes
```