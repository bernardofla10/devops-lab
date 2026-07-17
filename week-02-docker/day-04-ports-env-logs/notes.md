# Day 04 - Docker Ports, Environment Variables and Logs

## Goal

Understand how to expose container ports, pass environment variables and inspect container logs.

## Why this matters for DevOps

Real applications need configuration and observability.

DevOps work often requires answering:

- Which port is the app listening on?
- Which host port exposes the container?
- Which environment variables are being used?
- Is the app healthy?
- What do the logs say?
- Why is the container not reachable?

## Port mapping

Docker port mapping uses:

```text
HOST_PORT:CONTAINER_PORT
```

Example:

```bash
-p 8084:3000
```

Meaning:

```text
localhost:8084 -> container port 3000
```

## Environment variables

Environment variables configure containers at runtime.

Examples:

```bash
-e APP_ENV=development
-e PORT=3000
```

Or using an env file:

```bash
--env-file .env
```

## Logs

Containers should write logs to stdout/stderr.

Docker can read them with:

```bash
docker logs container-name
```

## Commands practiced

- `docker run -p`
- `docker run -e`
- `docker run --env-file`
- `docker port`
- `docker inspect`
- `docker logs`
- `docker logs -f`
- `docker logs --tail`
- `docker logs --since`
- `docker exec`
- `printenv`

## Important lessons

- `EXPOSE` in Dockerfile documents a port but does not publish it.
- `-p HOST_PORT:CONTAINER_PORT` publishes a container port on the host.
- Two containers can use the same internal port.
- Two containers cannot bind the same host port at the same time.
- Environment variables should configure runtime behavior.
- `.env` should not be committed to GitHub.
- `.env.example` documents required variables.
- `docker inspect` can reveal environment variables.
- Logs should go to stdout/stderr.
- `docker logs` is essential for debugging.

## Debugging flow

If a container is not reachable:

```bash
docker ps
docker port container-name
docker logs --tail 50 container-name
docker inspect container-name
curl http://localhost:HOST_PORT/health
```

Then check:

- Is the container running?
- Is the app listening on the expected container port?
- Is the host port mapped correctly?
- Is another container using the same host port?
- Did I use the correct URL?
- Are environment variables correct?
- Do logs show startup errors?

## Mistakes or doubts

- I confused host port and container port.
- I tried to access port 3000 instead of 8084.
- I forgot to pass the `PORT` variable.
- I reused a host port that was already taken.
- I forgot that environment variables can appear in `docker inspect`.

## Next step

Study Docker volumes and persistent data.