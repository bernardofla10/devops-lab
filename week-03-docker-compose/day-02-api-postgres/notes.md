# Day 02 - Docker Compose with API and PostgreSQL

## Goal

Understand how Docker Compose manages a multi-container application composed of an API and a PostgreSQL database.

## Architecture

```text
Host
  |
  | localhost:8090
  v
API
  |
  | db:5432
  v
PostgreSQL
  |
  v
Named volume
```

## Services

The Compose project has two services:

- `api`
- `db`

## Service discovery

Compose creates an internal network.

The API connects to PostgreSQL using:

```text
db:5432
```

The name `db` comes from the Compose service name.

## Localhost

Inside the API container:

```text
localhost = API container
```

It does not mean the PostgreSQL container.

## PostgreSQL health check

The database uses:

```bash
pg_isready
```

The API depends on:

```yaml
condition: service_healthy
```

This prevents the API from starting before PostgreSQL is ready.

## Persistent storage

PostgreSQL data is stored in a named volume:

```yaml
postgres-data:/var/lib/postgresql
```

The volume survives:

```bash
docker compose down
```

The volume is removed by:

```bash
docker compose down -v
```

## Database initialization

The file:

```text
db/init.sql
```

is mounted in:

```text
/docker-entrypoint-initdb.d/
```

It runs only when the database data directory is empty.

## Commands practiced

- `docker compose config`
- `docker compose up`
- `docker compose ps`
- `docker compose logs`
- `docker compose exec`
- `docker compose stop`
- `docker compose start`
- `docker compose restart`
- `docker compose down`
- `docker compose down -v`
- `pg_isready`
- `psql`

## Important lessons

- Multi-container applications can be defined in one Compose file.
- Services communicate using service names.
- Container IP addresses should not be hardcoded.
- `depends_on` alone does not guarantee application readiness.
- Health checks can represent service readiness.
- PostgreSQL data needs a named volume.
- Database initialization scripts run only on a fresh data directory.
- The database does not need to publish its port to the host for the API to reach it.
- The API should not expose the database password through an endpoint.
- Parameterized SQL queries help prevent SQL injection.
- Applications should tolerate temporary dependency failures.
- Logs from API and database can be inspected separately.

## Debugging flow

```bash
docker compose config
docker compose ps
docker compose logs --tail 50 db
docker compose logs --tail 50 api
docker compose exec db pg_isready
docker compose exec api sh
```

Then check:

- Is the Compose YAML valid?
- Is PostgreSQL healthy?
- Is the API healthy?
- Is `DB_HOST` equal to `db`?
- Is the API using port `5432` internally?
- Are database credentials consistent?
- Does the database exist?
- Does the `items` table exist?
- Is the named volume mounted correctly?
- Was the volume removed accidentally?
- Did the initialization script run?
- Are logs showing connection errors?

## Mistakes or doubts

- I used `localhost` as `DB_HOST`.
- I exposed PostgreSQL unnecessarily.
- I forgot the database health check.
- I used `depends_on` without `service_healthy`.
- I mounted the PostgreSQL 18 volume at the old path.
- I changed `init.sql` but kept the initialized volume.
- I ran `docker compose down -v` and deleted the database.
- I used inconsistent credentials between API and PostgreSQL.

## Next step

Add Adminer and split the application into frontend and backend networks.