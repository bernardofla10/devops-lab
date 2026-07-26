# Docker Compose Scaling and Recovery Cheatsheet

## Start with replicas

```bash
docker compose up -d --build --scale api=3
```

## Scale an existing service

```bash
docker compose up -d --scale api=2
docker compose up -d --scale api=4
```

## List replicas

```bash
docker compose ps api
docker compose ps -q api
```

## Logs from all replicas

```bash
docker compose logs api
docker compose logs -f api
```

## Execute in one replica

```bash
docker compose exec api hostname
```

## Execute in every replica

```bash
for id in $(docker compose ps -q api); do
  docker exec "$id" hostname
done
```

## Restart policies

```yaml
restart: "no"
restart: always
restart: on-failure
restart: on-failure:3
restart: unless-stopped
```

## Resource limits

```yaml
cpus: "0.50"
mem_limit: 128m
mem_reservation: 64m
pids_limit: 100
```

## Inspect restart count

```bash
docker inspect \
  -f '{{.RestartCount}}' \
  container-id
```

## Kill one replica

```bash
docker kill container-id
```

## Inspect resource configuration

```bash
docker inspect \
  -f '
Memory={{.HostConfig.Memory}}
NanoCPUs={{.HostConfig.NanoCpus}}
PidsLimit={{.HostConfig.PidsLimit}}
' \
  container-id
```

## Resource usage

```bash
docker stats
docker stats --no-stream
```

## Scalable service rules

A service intended for scaling should generally avoid:

```yaml
container_name: fixed-name
```

and fixed host ports:

```yaml
ports:
  - "8093:3000"
```

Prefer:

```yaml
expose:
  - "3000"
```

and place a gateway in front:

```text
host -> gateway -> API replicas
```

## Stateless vs stateful

```text
Stateless API
  can be replicated

Stateful PostgreSQL
  requires a proper replication design
  must not be scaled naively
```

## Restart policy vs healthcheck

```text
healthcheck
  reports starting, healthy or unhealthy

restart policy
  acts when the container exits
```

## Compose scaling limitation

```text
multiple replicas on one host
  protects against one process/container failure

host failure
  stops every local replica
```