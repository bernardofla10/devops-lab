# Day 07 - Containerize a Simple API

## Goal

Create a final Docker fundamentals mini-project by containerizing a simple API.

## Why this matters for DevOps

A real DevOps workflow often requires:

- building application images
- running containers with runtime configuration
- exposing ports
- reading logs
- persisting data
- connecting containers through networks
- validating health checks
- debugging with `docker inspect` and `docker exec`

## What this lab includes

This lab includes:

- a Node.js API
- a Dockerfile
- environment variables
- named volume persistence
- Docker custom network
- port mapping
- JSON logs
- Docker healthcheck
- helper scripts

## Image

```bash
devops-api:week02-final
```

## Container

```bash
devops-api-day07
```

## Port mapping

```bash
-p 8088:3000
```

Meaning:

```text
host port 8088 -> container port 3000
```

## Volume

```bash
-v devops-api-data-day07:/data
```

Meaning:

```text
Docker named volume -> /data inside container
```

## Network

```bash
--network devops-api-net-day07
```

This allows other containers in the same network to call:

```text
http://devops-api-day07:3000
```

## Environment variables

The app uses:

- `APP_NAME`
- `APP_ENV`
- `PORT`
- `DATA_DIR`

## Important lessons

- A Dockerfile makes the application image reproducible.
- Runtime configuration should be passed through environment variables.
- The host accesses the API through the published host port.
- Other containers access the API through the container name and container port.
- Persistent data should be stored in a volume.
- Logs should go to stdout/stderr.
- `docker inspect` is essential for debugging.
- Health checks help identify whether a container is healthy.
- Containers should be disposable, but important data should not be.

## Debugging flow

If the API does not work:

```bash
docker ps
docker logs --tail 50 devops-api-day07
docker port devops-api-day07
docker inspect devops-api-day07
docker exec -it devops-api-day07 sh
curl http://localhost:8088/health
```

Then check:

- Is the container running?
- Is the healthcheck passing?
- Is the port mapping correct?
- Are environment variables correct?
- Is the volume mounted?
- Is the application writing to `/data`?
- Is the API listening on `0.0.0.0`?
- Is the network correct for container-to-container traffic?
- Are logs showing errors?

## Mistakes or doubts

Write here what failed or confused you today.

Examples:

- I forgot to rebuild the image after changing code.
- I forgot to recreate the container after rebuilding.
- I used the wrong host port.
- I used `localhost` inside another container.
- I forgot to mount the volume.
- I expected data to persist after removing the volume.
- I forgot that `.env` should not be committed.

## Next step

Start Week 03: Docker Compose.