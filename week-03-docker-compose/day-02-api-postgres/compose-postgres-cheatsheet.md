# Docker Compose API and PostgreSQL Cheatsheet

## Validate configuration

```bash
docker compose config
docker compose config --services
docker compose config --images
```

## Start stack

```bash
docker compose up -d --build
```

## Service status

```bash
docker compose ps
docker compose ps -a
```

## Logs

```bash
docker compose logs
docker compose logs db
docker compose logs api
docker compose logs --tail 30 db
docker compose logs --tail 30 api
docker compose logs -f api db
```

## Execute commands

### API shell

```bash
docker compose exec api sh
```

### PostgreSQL shell

```bash
docker compose exec db \
  psql -U devops -d devopsdb
```

## Database commands

```sql
\dt
\d items
SELECT * FROM items ORDER BY id;
SELECT current_database();
SELECT current_user;
```

## Database health

```bash
docker compose exec db \
  pg_isready -U devops -d devopsdb
```

## API to database address

```text
host: db
port: 5432
```

## Host to API address

```text
http://localhost:8090
```

## Stop services

```bash
docker compose stop
```

## Start stopped services

```bash
docker compose start
```

## Remove containers and preserve database

```bash
docker compose down
```

## Remove containers and database volume

```bash
docker compose down -v
```

## Important startup rule

```yaml
depends_on:
  db:
    condition: service_healthy
```

This waits for the database health check before starting the API.

## PostgreSQL health check

```yaml
healthcheck:
  test:
    [
      "CMD-SHELL",
      "pg_isready -U $${POSTGRES_USER} -d $${POSTGRES_DB}"
    ]
```

## PostgreSQL 18 volume

```yaml
volumes:
  - postgres-data:/var/lib/postgresql
```

## Initialization script

```yaml
volumes:
  - ./db/init.sql:/docker-entrypoint-initdb.d/001-init.sql:ro
```

Initialization scripts run only when the PostgreSQL data directory is empty.