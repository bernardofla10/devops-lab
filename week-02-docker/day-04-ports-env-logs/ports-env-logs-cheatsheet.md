# Docker Ports, Environment Variables and Logs Cheatsheet

## Port mapping

```bash
docker run -p 8084:3000 image-name
```

Meaning:

```text
host port 8084 -> container port 3000
```

Format:

```text
HOST_PORT:CONTAINER_PORT
```

## Check published ports

```bash
docker port container-name
```

## Inspect port bindings

```bash
docker inspect -f '{{json .NetworkSettings.Ports}}' container-name
```

## Pass environment variables

```bash
docker run \
  -e APP_ENV=development \
  -e PORT=3000 \
  image-name
```

## Pass environment file

```bash
docker run --env-file .env image-name
```

## Inspect container environment variables

```bash
docker inspect -f '{{range .Config.Env}}{{println .}}{{end}}' container-name
```

## Execute command inside container

```bash
docker exec container-name printenv
docker exec -it container-name sh
```

## Logs

### All logs

```bash
docker logs container-name
```

### Last lines

```bash
docker logs --tail 20 container-name
```

### Follow logs

```bash
docker logs -f container-name
```

### Logs with timestamps

```bash
docker logs -t container-name
```

### Logs since time

```bash
docker logs --since 5m container-name
```

## Common port problems

### Wrong port mapping

If the container runs on port 3000 and I use:

```bash
-p 8084:3000
```

I must access:

```text
http://localhost:8084
```

not:

```text
http://localhost:3000
```

### Port already in use

Two containers cannot bind the same host port at the same time.

This fails if port 8084 is already used:

```bash
docker run -p 8084:3000 image-name
```

Use another host port:

```bash
docker run -p 8085:3000 image-name
```

## Security note

Environment variables can be visible through `docker inspect`.

Do not treat plain environment variables as a complete secret-management solution for production.