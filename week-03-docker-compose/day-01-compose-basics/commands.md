# Day 01 - Docker Compose Basics

## Check Compose

```bash
docker compose version
docker version
docker info
```

## Prepare environment

```bash
cp .env.example .env
```

## Validate configuration

```bash
docker compose config
docker compose config --services
```

## Build

```bash
docker compose build
```

## Start stack

```bash
docker compose up -d --build
```

## Check services

```bash
docker compose ps
docker compose ps -a
docker compose images
docker compose top
```

## Test endpoints

```bash
curl http://localhost:8089
curl http://localhost:8089/health
curl http://localhost:8089/config
curl http://localhost:8089/items
curl "http://localhost:8089/items/add?title=first-compose-item"
curl "http://localhost:8089/items/add?title=second-compose-item"
curl http://localhost:8089/items
curl http://localhost:8089/error
```

## Logs

```bash
docker compose logs
docker compose logs api
docker compose logs --tail 20 api
docker compose logs -f api
```

## Execute commands

```bash
docker compose exec api sh
docker compose exec api printenv APP_NAME
docker compose exec api printenv APP_ENV
docker compose exec api cat /data/items.json
```

## Inspect resources

```bash
docker network ls | grep devops-compose-day01
docker network inspect devops-compose-day01_default

docker volume ls | grep devops-compose-day01
docker volume inspect devops-compose-day01_api-data

docker inspect "$(docker compose ps -q api)"
```

## Lifecycle

```bash
docker compose stop
docker compose start
docker compose restart
docker compose pause
docker compose unpause
```

## Remove stack and preserve data

```bash
docker compose down
```

## Remove stack and persistent data

```bash
docker compose down -v
```

## Rebuild after code changes

```bash
docker compose up -d --build
```

## Helper scripts

```bash
chmod +x scripts/*.sh

./scripts/up.sh
./scripts/test.sh
./scripts/inspect.sh
./scripts/down.sh
./scripts/down.sh --volumes
```