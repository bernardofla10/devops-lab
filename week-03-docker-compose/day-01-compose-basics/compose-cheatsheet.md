# Docker Compose Basics Cheatsheet

## Validate configuration

```bash
docker compose config
```

## List declared services

```bash
docker compose config --services
```

## Build services

```bash
docker compose build
```

## Start services

```bash
docker compose up
```

Run in background:

```bash
docker compose up -d
```

Build before starting:

```bash
docker compose up -d --build
```

## Show service status

```bash
docker compose ps
docker compose ps -a
```

## Show images

```bash
docker compose images
```

## Show processes

```bash
docker compose top
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
docker compose exec api printenv
```

## Stop services

```bash
docker compose stop
```

## Start stopped services

```bash
docker compose start
```

## Restart services

```bash
docker compose restart
```

## Pause and unpause

```bash
docker compose pause
docker compose unpause
```

## Remove containers and project network

```bash
docker compose down
```

## Remove containers, network and volumes

```bash
docker compose down -v
```

## Important difference

```text
docker compose stop
  stops containers
  keeps containers
  keeps networks
  keeps volumes

docker compose down
  removes containers
  removes project network
  keeps named volumes

docker compose down -v
  removes containers
  removes project network
  removes named volumes
  deletes persistent data
```

## Rebuild after source-code changes

```bash
docker compose up -d --build
```

## Port interpolation

```yaml
ports:
  - "${HOST_PORT:-8089}:3000"
```

## Environment variables

```yaml
environment:
  APP_NAME: "${APP_NAME:-compose-api}"
  APP_ENV: "${APP_ENV:-development}"
```

## Named volume

```yaml
services:
  api:
    volumes:
      - api-data:/data

volumes:
  api-data:
```