# Day 03 - Dockerfile Basics

## Goal

Understand how to create a custom Docker image using a Dockerfile.

## Why this matters for DevOps

Dockerfiles are used to package applications in a reproducible way.

They are important for:

- local development
- CI/CD pipelines
- production deployments
- container registries
- Kubernetes workloads
- cloud deployments

## Key concepts

A Dockerfile is a set of instructions used to build a Docker image.

The image can then be used to create containers.

## Build flow

```text
Dockerfile + project files
        ↓
docker build
        ↓
Docker image
        ↓
docker run
        ↓
container
```

## Dockerfile instructions practiced

- `FROM`
- `LABEL`
- `WORKDIR`
- `COPY`
- `EXPOSE`
- `CMD`

## Important lessons

- `FROM` defines the base image.
- `COPY` copies files from the build context into the image.
- `WORKDIR` defines the working directory inside the image.
- `EXPOSE` documents the container port but does not publish it.
- `CMD` defines the default command when the container starts.
- `docker build` creates an image.
- `docker run` creates and starts a container from the image.
- Changing local files does not change an already built image.
- After changing files, I need to rebuild the image.
- After rebuilding, I need to recreate the container to use the new image.
- `.dockerignore` helps keep the build context clean and safe.

## Commands practiced

- `docker build`
- `docker run`
- `docker images`
- `docker image inspect`
- `docker history`
- `docker logs`
- `docker exec`
- `docker tag`
- `docker rm`
- `docker rmi`

## Image created

```bash
devops-nginx:day03
```

## Container created

```bash
dockerfile-nginx
```

## Port mapping

```bash
-p 8083:80
```

Meaning:

```text
host port 8083 -> container port 80
```

## Mistakes or doubts

Write here what failed or confused you today.

Examples:

- I forgot the final `.` in `docker build`.
- I changed `index.html` but forgot to rebuild the image.
- I rebuilt the image but forgot to recreate the container.
- I expected `EXPOSE 80` to publish the port automatically.
- I had a wrong `COPY` path.
- I forgot to use `.dockerignore`.

## Next step

Study ports, environment variables and logs in containers.