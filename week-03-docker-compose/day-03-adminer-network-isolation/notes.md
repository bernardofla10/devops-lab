# Day 03 - Adminer and Compose Network Isolation

## Goal

Add Adminer to the API and PostgreSQL stack while introducing Docker Compose profiles and explicit network isolation.

## Services

The stack contains:

- API
- PostgreSQL
- Adminer

## Adminer

Adminer is a web-based database administration tool.

It connects to PostgreSQL using:

```text
db:5432
```

The Adminer interface is published locally at:

```text
http://localhost:8092
```

## Profiles

Adminer belongs to the `tools` profile.

Core stack:

```bash
docker compose up -d
```

Stack with Adminer:

```bash
docker compose --profile tools up -d
```

Profiles make development and debugging tools optional.

## Networks

The project declares:

- `public-net`
- `private-net`

### Public network

Members:

- API
- Adminer

### Private network

Members:

- API
- Adminer
- PostgreSQL

PostgreSQL does not participate in the public network.

## Internal network

The private network uses:

```yaml
internal: true
```

This provides additional isolation from external network connectivity.

## Selective port publishing

The API publishes:

```text
127.0.0.1:8091 -> 3000
```

Adminer publishes:

```text
127.0.0.1:8092 -> 8080
```

PostgreSQL does not publish a host port.

## Service discovery

API and Adminer use the service name:

```text
db
```

The IP address may change, but the Compose service name remains the correct connection target.

## Commands practiced

- `docker compose --profile`
- `docker compose config --profiles`
- `docker compose config --networks`
- `docker network inspect`
- `docker compose port`
- `docker inspect`
- `docker compose logs`
- `docker compose exec`

## Important lessons

- Services need a shared network to communicate.
- PostgreSQL can remain isolated from the public application network.
- A database does not need a host port for internal application access.
- `expose` does not publish a port on the host.
- Profiles are useful for optional development tools.
- Adminer should not be part of the required production stack.
- `localhost` inside Adminer does not point to PostgreSQL.
- The correct PostgreSQL host is `db`.
- Binding tools to `127.0.0.1` limits local exposure.
- Named volumes preserve data independently of container lifecycle.

## Debugging flow

```bash
docker compose --profile tools config -q
docker compose --profile tools ps
docker compose logs --tail 50 db
docker compose logs --tail 50 api
docker compose --profile tools logs --tail 50 adminer
docker network inspect devops-compose-day03_private-net
```

Then check:

- Is the `tools` profile active?
- Is Adminer running?
- Is PostgreSQL healthy?
- Is the server field in Adminer set to `db`?
- Are the database credentials correct?
- Do Adminer and PostgreSQL share `private-net`?
- Is PostgreSQL accidentally connected to `public-net`?
- Is PostgreSQL accidentally published on the host?
- Is the Adminer host port correct?
- Was the database volume removed?

## Mistakes or doubts

- I started Compose without activating the Adminer profile.
- I used `localhost` as the Adminer server.
- I connected PostgreSQL to the public network.
- I published port 5432 unnecessarily.
- I confused `expose` with `ports`.
- I forgot that the API needs both networks.
- I ran `down -v` and removed the database.

## Next step

Study service scaling, restart policies, resource limits and container failure recovery.