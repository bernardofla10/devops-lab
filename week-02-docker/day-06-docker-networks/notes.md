# Day 06 - Docker Networks

## Goal

Understand Docker networks and how containers communicate with each other.

## Why this matters for DevOps

Real systems usually have multiple services:

- frontend
- backend
- database
- cache
- reverse proxy
- monitoring agent
- worker process

These services need to communicate securely and predictably.

Docker networks allow containers to communicate with each other by name.

## Key concepts

## Host to container

To access a container from the host machine, publish a port:

```bash
-p 8087:3000
```

Then access:

```text
http://localhost:8087
```

## Container to container

To allow one container to call another container, put both containers in the same Docker network.

Example:

```text
client container -> http://api-day06:3000/health
```

## Custom bridge network

A custom bridge network provides container DNS by name.

```bash
docker network create devops-net-day06
```

Then run containers with:

```bash
--network devops-net-day06
```

## Localhost warning

Inside a container:

```text
localhost = the container itself
```

So if a client container calls:

```text
http://localhost:3000
```

it is trying to call itself, not the API container.

To call the API container, use:

```text
http://api-day06:3000
```

## Commands practiced

- `docker network ls`
- `docker network create`
- `docker network inspect`
- `docker network connect`
- `docker network disconnect`
- `docker run --network`
- `docker port`
- `docker inspect`
- `docker logs`

## Important lessons

- Containers in the same custom network can resolve each other by name.
- Containers in different networks are isolated by default.
- Published ports are mainly for host-to-container access.
- Container-to-container traffic should use the container port, not the host port.
- `localhost` inside a container does not mean the host machine.
- `docker network inspect` shows which containers are attached to a network.
- A container can be connected to more than one Docker network.

## Debugging flow

If one container cannot reach another:

```bash
docker ps
docker network ls
docker network inspect network-name
docker inspect container-name
docker logs container-name
docker port container-name
```

Then check:

- Are both containers running?
- Are both containers in the same network?
- Is the target container name correct?
- Is the target application listening on `0.0.0.0`?
- Is the client using the container port?
- Is the client incorrectly using `localhost`?
- Are logs showing connection errors?

## Mistakes or doubts

Write here what failed or confused you today.

Examples:

- I tried to use `localhost` from the client container.
- I used the host port instead of the container port.
- I forgot to create the custom network.
- I forgot to pass `--network`.
- I expected containers in different networks to communicate.
- I forgot that container names work as DNS names in custom networks.

## Next step

Containerize a simple API as the final Docker fundamentals project.