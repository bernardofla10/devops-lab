# Day 01 - Docker Installation and First Containers

## Goal

Install Docker, understand the difference between images and containers, and run the first containers.

## Why this matters for DevOps

Containers are a core part of modern DevOps workflows.

They help with:

- reproducible environments
- local development
- CI/CD pipelines
- deployment
- dependency isolation
- running services consistently across machines

## Key concepts

## Image

An image is a packaged template.

It contains the application, dependencies and runtime configuration needed to create containers.

## Container

A container is an instance of an image.

It can be running, stopped or removed.

## Important mental model

```text
image     = package/template
container = running/stopped instance
```

## Commands practiced

- `docker --version`
- `docker version`
- `docker info`
- `docker run`
- `docker ps`
- `docker ps -a`
- `docker images`
- `docker pull`
- `docker logs`
- `docker exec`
- `docker stop`
- `docker start`
- `docker rm`

## Important lessons

- `docker run` creates and starts a new container.
- `docker ps` shows running containers.
- `docker ps -a` shows all containers, including stopped ones.
- `docker images` shows local images.
- `docker logs` shows container logs.
- `docker exec` runs a command inside an existing running container.
- `-d` runs a container in detached mode.
- `-p host_port:container_port` maps a port from the host to the container.
- `--rm` removes the container after it exits.

## Nginx lab

I ran Nginx in a container:

```bash
docker run -d --name nginx-day01 -p 8081:80 nginx:alpine
```

Then I tested it with:

```bash
curl http://localhost:8081
curl -I http://localhost:8081
```

## Mistakes or doubts

- I forgot that `docker ps` only shows running containers.
- I used port 8080 but it conflicted with my previous Nginx lab.
- I forgot to remove an old container before creating a new one with the same name.
- I tried to use `bash` inside Alpine, but Alpine usually has `sh`.

## Next step

Study Docker image and container lifecycle more deeply.