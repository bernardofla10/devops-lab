# Day 01 - Docker Compose Basics

## Goal

Understand the basic structure and lifecycle of a Docker Compose project.

## Why Docker Compose matters

Running containers manually can require several commands for:

- building images
- creating networks
- creating volumes
- publishing ports
- passing environment variables
- starting containers

Docker Compose moves this configuration into a declarative YAML file.

## Main file

```text
compose.yaml
```

## Main structure

```yaml
services:
  api:
    build:
      context: .
    ports:
      - "8089:3000"
    environment:
      APP_ENV: development
    volumes:
      - api-data:/data

volumes:
  api-data:
```

## Service

A service defines how Compose should create and run one application component.

The service in this lab is:

```text
api
```

## Build

Compose builds the API image from the local Dockerfile.

```yaml
build:
  context: .
  dockerfile: Dockerfile
```

## Ports

```yaml
ports:
  - "${HOST_PORT:-8089}:3000"
```

Meaning:

```text
host port 8089 -> container port 3000
```

## Environment variables

The `.env` file provides values used by Compose.

The `environment` section defines variables available inside the container.

## Volume

```yaml
volumes:
  - api-data:/data
```

The volume allows data to survive container recreation.

## Default network

Compose creates a project network automatically.

Services attached to this network can communicate using service names.

## Commands practiced

- `docker compose version`
- `docker compose config`
- `docker compose build`
- `docker compose up`
- `docker compose ps`
- `docker compose logs`
- `docker compose exec`
- `docker compose stop`
- `docker compose start`
- `docker compose restart`
- `docker compose pause`
- `docker compose unpause`
- `docker compose down`

## Important lessons

- Compose configuration is declarative.
- One Compose command can replace several manual Docker commands.
- `docker compose config` validates and resolves the configuration.
- `docker compose up -d --build` builds and starts the stack.
- Compose creates a default project network.
- Named volumes persist after `docker compose down`.
- `docker compose down -v` removes named volumes and their data.
- Source-code changes copied by a Dockerfile require an image rebuild.
- `docker compose exec` uses a service name instead of a full container name.
- `.env` should not be committed.
- `.env.example` should document expected variables.

## Debugging flow

```bash
docker compose config
docker compose ps
docker compose logs --tail 50 api
docker compose exec api sh
docker compose images
docker compose top
```

Then check:

- Is the YAML valid?
- Were environment variables resolved?
- Was the image built?
- Is the service running?
- Is the healthcheck passing?
- Is the host port correct?
- Is the named volume mounted?
- Do the logs show an application error?
- Was the image rebuilt after changing the source code?

## Mistakes or doubts

- I forgot to create `.env`.
- I used the wrong YAML indentation.
- I changed the source code without rebuilding the image.
- I confused the service name with the generated container name.
- I used `docker compose down -v` and removed persistent data.
- I expected `docker compose stop` to remove containers.
- I forgot that `docker compose down` removes the project network.

## Next step

Add PostgreSQL as a second Compose service and connect the API to the database using the service name.