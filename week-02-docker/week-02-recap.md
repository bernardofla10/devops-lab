# Week 02 Recap - Docker Fundamentals

## Main goal

Build practical Docker foundations for DevOps work.

## What I practiced

### Day 01 - Docker installation and first containers

- installed Docker
- ran `hello-world`
- ran Alpine containers
- ran Nginx container
- used `docker run`, `docker ps`, `docker logs`, `docker exec`

### Day 02 - Images, containers and lifecycle

- image vs container
- `docker create`
- `docker start`
- `docker stop`
- `docker restart`
- `docker pause`
- `docker unpause`
- `docker inspect`
- `docker stats`
- `docker top`
- `docker cp`

### Day 03 - Dockerfile basics

- wrote a Dockerfile
- built a custom image
- used `FROM`, `WORKDIR`, `COPY`, `EXPOSE`, `CMD`
- used `.dockerignore`
- rebuilt images after changing files

### Day 04 - Ports, environment variables and logs

- used `-p HOST_PORT:CONTAINER_PORT`
- passed variables with `-e`
- used `--env-file`
- inspected environment variables
- used `docker logs`
- created an app with `/health`, `/config` and `/error`

### Day 05 - Volumes and persistent data

- understood ephemeral container data
- created named volumes
- used bind mounts
- inspected mounts
- persisted data across container recreation

### Day 06 - Docker networks

- created custom networks
- connected containers by name
- understood `localhost` inside containers
- tested network isolation
- used `docker network inspect`

### Day 07 - Containerized API final lab

- built a complete containerized API
- used ports, env vars, logs, volumes and networks together
- added healthcheck
- created helper scripts
- tested persistence and container-to-container communication

## Most important commands

```bash
docker build
docker run
docker ps
docker ps -a
docker images
docker logs
docker exec
docker inspect
docker stop
docker start
docker restart
docker rm
docker rmi
docker volume create
docker volume ls
docker volume inspect
docker network create
docker network ls
docker network inspect
docker port
docker stats
docker top
```

## Key lessons

- Images are templates; containers are instances.
- Containers are disposable.
- Important data should live in volumes.
- Host-to-container access uses published ports.
- Container-to-container access uses Docker networks.
- `localhost` inside a container means the container itself.
- Environment variables configure containers at runtime.
- `.env` should not be committed.
- Logs should go to stdout/stderr.
- Dockerfiles make builds reproducible.
- `.dockerignore` keeps the build context clean and safer.
- `docker inspect` is one of the most important debugging tools.

## Ready for Week 03

The next step is Docker Compose.

The goal for Week 03 is to manage multiple containers as one application stack:

- API
- database
- admin tool
- network
- volumes
- environment variables
- health checks
- logs