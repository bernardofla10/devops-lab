# Day 07 - Production-like Docker Compose Stack

This is the final project for Docker Compose Week 03.

## Features

- Node.js API
- PostgreSQL 18
- Nginx gateway
- database migration job
- health and readiness endpoints
- Compose secrets
- Compose configs
- Adminer profile
- integration-test profile
- development override
- production override
- database backup and restore
- operational runbook

## Architecture

```text
Host
  |
  v
Nginx gateway
  |
  v
Node.js API
  |
  v
PostgreSQL
```

Startup dependency:

```text
PostgreSQL healthy
  ↓
migration completed successfully
  ↓
API healthy
  ↓
gateway starts
```

## Prepare local files

```bash
cp env/development.env.example env/development.env
cp env/production.env.example env/production.env

cp secrets/db_password.example secrets/db_password.txt
chmod 600 secrets/db_password.txt
```

## Development

```bash
./scripts/up.sh dev --tools
```

URLs:

```text
Gateway:    http://localhost:8099
Direct API: http://localhost:8100
Adminer:    http://localhost:8101
PostgreSQL: localhost:5434
```

## Production simulation

```bash
./scripts/up.sh prod
```

URL:

```text
http://localhost:8102
```

## Integration tests

```bash
./scripts/test.sh dev
./scripts/test.sh prod
```

## Run migrations

```bash
./scripts/migrate.sh dev
./scripts/migrate.sh prod
```

## Backup

```bash
./scripts/backup.sh dev
./scripts/backup.sh prod
```

## Restore

```bash
./scripts/restore.sh dev backups/file.sql
./scripts/restore.sh prod backups/file.sql
```

## Inspect

```bash
./scripts/inspect.sh dev
./scripts/inspect.sh prod
```

## Stop

```bash
./scripts/down.sh dev
./scripts/down.sh prod
```

Remove database volumes:

```bash
./scripts/down.sh dev --volumes
./scripts/down.sh prod --volumes
```

## Security notes

- Database credentials are not stored in the Docker image.
- The password is mounted as a Compose secret.
- Only authorized services receive the secret.
- PostgreSQL and API ports are not published in the production configuration.
- The API uses a read-only root filesystem in the production override.
- Backup files are ignored by Git and should be treated as sensitive.