# Docker Networks Cheatsheet

## Core idea

Containers can communicate with each other through Docker networks.

Containers in the same custom bridge network can resolve each other by container name.

## List networks

```bash
docker network ls
```

## Inspect network

```bash
docker network inspect bridge
docker network inspect devops-net-day06
```

## Create custom network

```bash
docker network create devops-net-day06
```

## Run container in custom network

```bash
docker run -d \
  --name api-day06 \
  --network devops-net-day06 \
  -p 8087:3000 \
  devops-network-api:day06
```

## Call container by name

From another container in the same network:

```bash
docker run --rm \
  --network devops-net-day06 \
  -e TARGET_URL=http://api-day06:3000/health \
  devops-network-client:day06
```

## Connect existing container to network

```bash
docker network connect isolated-net-day06 api-day06
```

## Disconnect container from network

```bash
docker network disconnect isolated-net-day06 api-day06
```

## Check container IP

```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' api-day06
```

## Check published ports

```bash
docker port api-day06
```

## Important distinction

```text
localhost inside a container = the container itself
localhost on host            = your machine
api-day06:3000               = another container in the same network
```

## Host access vs container access

### Host to container

Use published ports:

```bash
docker run -p 8087:3000 image-name
curl http://localhost:8087
```

### Container to container

Use container name in the same network:

```text
http://api-day06:3000
```

## Common problems

- Containers are not in the same network
- Using `localhost` inside a container expecting another container
- Forgetting `--network`
- Using host port instead of container port for container-to-container traffic
- Container is stopped
- Application is listening only on `127.0.0.1` instead of `0.0.0.0`