# Day 02 - Docker Compose with API and PostgreSQL

This lab introduces a multi-container Docker Compose application with:

- a Node.js API
- a PostgreSQL database
- service discovery
- database health checks
- dependency conditions
- persistent database storage
- database initialization
- API and database debugging commands

## Architecture

```text
Host
  |
  | localhost:8090
  v
API service
  |
  | db:5432
  v
PostgreSQL service
  |
  | /var/lib/postgresql
  v
Named volume
```

## Services

### API

The API exposes:

| Endpoint | Description |
|---|---|
| `/` | Application information |
| `/health` | API and database health |
| `/config` | Runtime configuration |
| `/db-info` | PostgreSQL information |
| `/items` | List database items |
| `/items/add?title=example` | Insert an item |
| `/error` | Simulated error |

### Database

The database uses:

- PostgreSQL 18
- `pg_isready` health check
- a named volume
- an initialization SQL file
- service discovery through the name `db`

## Prepare environment

```bash
cp .env.example .env
```

## Start

```bash
./scripts/up.sh
```

## Test

```bash
./scripts/test.sh
```

## Inspect

```bash
./scripts/inspect.sh
```

## Open PostgreSQL shell

```bash
./scripts/db-shell.sh
```

Exit with:

```text
\q
```

## Stop while preserving data

```bash
./scripts/down.sh
```

## Remove all data

```bash
./scripts/down.sh --volumes
```

## Reset the database

```bash
./scripts/reset-db.sh --confirm
```

## Main Compose commands

```bash
docker compose config
docker compose up -d --build
docker compose ps
docker compose logs
docker compose exec
docker compose stop
docker compose start
docker compose restart
docker compose down
docker compose down -v
```

## Important networking rule

The API connects to PostgreSQL using:

```text
db:5432
```

It does not use:

```text
localhost:5432
```

Inside the API container, `localhost` refers to the API container itself.