# Day 05 - Docker Volumes and Persistent Data

## Goal

Understand how Docker handles persistent data using named volumes and bind mounts.

## Why this matters for DevOps

Containers are designed to be disposable.

Applications often need persistent data, such as:

- database files
- uploaded files
- generated reports
- cache data
- logs
- local development files

If data is written only inside a container filesystem, it can be lost when the container is removed.

## Key concepts

## Ephemeral container data

Data written inside a container without a volume belongs to that container.

If the container is removed, the data is lost.

## Named volume

A named volume is managed by Docker.

Example:

```bash
-v devops-data-day05:/data
```

This mounts the Docker volume `devops-data-day05` into `/data` inside the container.

## Bind mount

A bind mount maps a host directory into the container.

Example:

```bash
-v "$PWD/host-data:/data"
```

This maps the local folder `host-data` into `/data` inside the container.

## Commands practiced

- `docker volume create`
- `docker volume ls`
- `docker volume inspect`
- `docker volume rm`
- `docker run -v`
- `docker inspect`
- `docker logs`
- `docker exec`
- `docker rm -f`

## Important lessons

- Containers are disposable.
- Data inside a container is not a safe persistence strategy.
- Volumes allow data to survive container removal.
- Named volumes are managed by Docker.
- Bind mounts use explicit host paths.
- Bind mounts are very useful in local development.
- Named volumes are useful for service data such as databases.
- `docker inspect` shows mounts and volume configuration.
- Removing a container does not automatically remove a named volume.
- Removing a bind-mounted container does not remove the host directory.

## Debugging flow

If data is missing:

```bash
docker ps -a
docker inspect container-name | grep -A 20 Mounts
docker volume ls
docker volume inspect volume-name
docker logs container-name
```

Then check:

- Was the container started with `-v`?
- Is the volume mounted at the correct path?
- Is the application writing to the mounted path?
- Did I recreate the container without the volume?
- Did I remove the named volume?
- Is the bind mount host path correct?

## Mistakes or doubts

- I expected data to persist without a volume.
- I confused named volume and bind mount.
- I mounted the volume at the wrong container path.
- I wrote data to a path different from `/data`.
- I removed the volume and lost the data.
- I expected removing a container to remove the named volume.

## Next step

Study Docker networks and how containers communicate with each other.