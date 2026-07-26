# Day 04 - Scaling, Restart Policies and Failure Recovery

## Goal

Understand how to scale a stateless Compose service and recover from container failures.

## Architecture

```text
Host
  |
Nginx gateway
  |
Multiple API replicas
  |
PostgreSQL
  |
Named volume
```

## Horizontal scaling

Horizontal scaling creates more instances of the same service.

Example:

```bash
docker compose up -d --scale api=3
```

The API can be scaled because persistent state is stored in PostgreSQL.

## Stateless API

Each API replica can be removed or recreated.

The replicas share:

- database schema
- database records
- runtime configuration

They do not depend on a local persistent filesystem.

## Stateful database

PostgreSQL is stateful.

Scaling a database requires a real replication architecture.

Running multiple PostgreSQL containers with the same volume is not a valid database cluster.

## Gateway

Nginx publishes the host port and forwards traffic to the API service.

```text
localhost:8093 -> gateway -> api:3000
```

The API replicas do not publish fixed host ports.

## Host port conflict

A fixed host port cannot be bound by multiple replicas simultaneously.

A scalable service should use its internal container port and remain behind a gateway or load balancer.

## Restart policies

The API uses:

```yaml
restart: on-failure:3
```

It restarts after a non-zero exit code.

The database and gateway use:

```yaml
restart: unless-stopped
```

## Healthcheck

Health checks report whether a container is healthy.

A healthcheck does not replace a restart policy.

## Failure recovery

The lab tested two failure types:

- killing one API container
- calling `/crash`, which exits the Node.js process

Other API replicas continued serving requests while Docker restarted the failed container.

## Resource limits

The API uses:

```yaml
cpus: "0.50"
mem_limit: 128m
mem_reservation: 64m
pids_limit: 100
```

Resource limits protect the host from one container consuming unlimited resources.

## Commands practiced

- `docker compose up --scale`
- `docker compose ps`
- `docker compose logs`
- `docker compose restart`
- `docker kill`
- `docker inspect`
- `docker stats`
- `docker exec`

## Important lessons

- A service must avoid `container_name` when it needs multiple replicas.
- A replicated service should not publish one fixed host port per replica.
- A gateway provides one stable host-facing endpoint.
- Stateless services are easier to scale horizontally.
- Stateful services require specialized replication.
- Restart policies react to container termination.
- Health checks report readiness and health.
- Resource limits should be based on measurements.
- Multiple containers on one host do not protect against host failure.
- Scaling application containers is different from scaling a database.
- Persistent state must live outside disposable API replicas.

## Debugging flow

```bash
docker compose config -q
docker compose ps
docker compose logs --tail 50 api
docker compose logs --tail 50 gateway
docker inspect container-id
docker stats --no-stream
```

Then check:

- How many API replicas are running?
- Are all replicas healthy?
- Did one replica restart?
- What is its restart count?
- Is the gateway healthy?
- Did the gateway resolve the current replicas?
- Is the database healthy?
- Is a fixed host port preventing scaling?
- Is `container_name` configured?
- Are CPU or memory limits too restrictive?
- Did the process exit or only become unhealthy?
- Is persistent state stored in PostgreSQL?

## Mistakes or doubts

- I tried to scale a service with `container_name`.
- I published the same fixed host port from every replica.
- I scaled PostgreSQL as if it were a stateless API.
- I expected a healthcheck to restart an unhealthy process.
- I confused `service.restart` with `depends_on.restart`.
- I forgot to restart the gateway after changing the replica count.
- I assumed multiple local containers protected against host failure.
- I set resource limits without observing normal usage.

## Next step

Study Compose overrides and separate development and production configurations.