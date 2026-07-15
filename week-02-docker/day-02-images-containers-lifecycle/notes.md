# Day 02 - Docker Images, Containers and Lifecycle

## Goal

Understand Docker image and container lifecycle.

## Why this matters for DevOps

DevOps work often requires managing containers in local environments, CI/CD pipelines and production servers.

I need to know how to:

- create containers
- start containers
- stop containers
- restart containers
- inspect containers
- read logs
- check resource usage
- copy files in and out of containers
- clean up unused containers

## Key concepts

## Image

An image is a packaged template used to create containers.

## Container

A container is an instance of an image.

A container can be:

- created
- running
- paused
- exited
- removed

## Lifecycle commands

```bash
docker create
docker start
docker run
docker stop
docker restart
docker pause
docker unpause
docker rm
```

## Important difference

```text
docker create = creates a container but does not start it
docker start  = starts an existing container
docker run    = creates and starts a new container
docker exec   = runs a command inside an existing running container
```

## Commands practiced

- `docker pull`
- `docker images`
- `docker image inspect`
- `docker create`
- `docker start`
- `docker run`
- `docker stop`
- `docker restart`
- `docker pause`
- `docker unpause`
- `docker inspect`
- `docker logs`
- `docker top`
- `docker stats`
- `docker cp`
- `docker rename`
- `docker rm`
- `docker rmi`

## Important lessons

- `docker ps` shows running containers.
- `docker ps -a` shows all containers.
- Containers can exist without running.
- `docker create` and `docker start` split what `docker run` does at once.
- `docker inspect` provides detailed metadata.
- `docker logs` shows application/container output.
- `docker top` shows processes inside a container.
- `docker stats` shows container resource usage.
- `docker cp` copies files between host and container.
- `docker rm -f` forcefully removes a container and should be used carefully.
- A container stops when its main process exits.

## Mistakes or doubts

- I forgot that `docker create` does not start the container.
- I expected `docker ps` to show stopped containers.
- I tried to remove a running container without `-f`.
- I confused `docker exec` with `docker run`.
- I forgot that Alpine uses `sh`, not necessarily `bash`.

## Next step

Study Dockerfile basics and build a custom image.