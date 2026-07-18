# Docker Volumes Cheatsheet

## Core idea

Containers are disposable.

Important data should live outside containers.

## Types of persistence

### Named volume

A named volume is managed by Docker.

```bash
docker volume create devops-data
docker run -v devops-data:/data image-name
```

Format:

```text
volume_name:container_path
```

### Bind mount

A bind mount maps a host directory into the container.

```bash
docker run -v "$PWD/host-data:/data" image-name
```

Format:

```text
host_path:container_path
```

## Volume commands

### Create volume

```bash
docker volume create devops-data
```

### List volumes

```bash
docker volume ls
```

### Inspect volume

```bash
docker volume inspect devops-data
```

### Remove volume

```bash
docker volume rm devops-data
```

## Run container with named volume

```bash
docker run -d \
  --name app \
  -p 8086:3000 \
  -v devops-data:/data \
  image-name
```

## Run container with bind mount

```bash
docker run -d \
  --name app \
  -p 8086:3000 \
  -v "$PWD/host-data:/data" \
  image-name
```

## Inspect mounts

```bash
docker inspect container-name | grep -A 20 Mounts
```

Or:

```bash
docker inspect -f '{{json .Mounts}}' container-name
```

## Named volume vs bind mount

| Type | Managed by | Best for |
|---|---|---|
| Named volume | Docker | persistent service data, databases, general container data |
| Bind mount | Host filesystem | local development, editing files from host, explicit host paths |

## Important lesson

Without a volume, data written inside a container is lost when the container is removed.

With a volume, data can survive container removal and be reused by a new container.