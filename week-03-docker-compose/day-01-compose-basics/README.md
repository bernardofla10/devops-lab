# Day 01 - Docker Compose Basics

This lab introduces Docker Compose by migrating the final API from Week 02 from manual Docker commands to a declarative Compose configuration.

## Goals

- Understand the structure of a `compose.yaml` file
- Define a service
- Build an image through Compose
- Publish a container port
- Pass environment variables
- Create and mount a named volume
- Manage the stack lifecycle
- Read logs and execute commands through Compose
- Validate the resolved Compose configuration

## Architecture

```text
Host
  |
  | localhost:8089
  v
API service
  |
  | /data
  v
Named volume
```

## Project structure

```text
.
├── compose.yaml
├── Dockerfile
├── .dockerignore
├── .env.example
├── app/
│   ├── package.json
│   └── server.js
└── scripts/
    ├── up.sh
    ├── test.sh
    ├── inspect.sh
    └── down.sh
```

## Environment setup

```bash
cp .env.example .env
```

## Validate configuration

```bash
docker compose config
```

## Start

```bash
./scripts/up.sh
```

Or manually:

```bash
docker compose up -d --build
```

## Test

```bash
./scripts/test.sh
```

The API is available at:

```text
http://localhost:8089
```

## Logs

```bash
docker compose logs api
docker compose logs -f api
```

## Execute commands

```bash
docker compose exec api sh
```

## Inspect

```bash
./scripts/inspect.sh
```

## Stop and remove containers

```bash
./scripts/down.sh
```

Named volumes are preserved.

## Remove containers and volumes

```bash
./scripts/down.sh --volumes
```

This permanently removes the lab data.

## Main commands

```bash
docker compose config
docker compose up -d --build
docker compose ps
docker compose logs
docker compose exec
docker compose stop
docker compose start
docker compose restart
docker compose down
docker compose down -v
```