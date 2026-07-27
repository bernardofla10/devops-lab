# Operational Runbook

## System overview

```text
Gateway
  ↓
API
  ↓
Migration job
  ↓
PostgreSQL
```

Optional services:

- Adminer
- integration tests

## Start development

```bash
./scripts/up.sh dev --tools
```

## Start production locally

```bash
./scripts/up.sh prod
```

## Check status

```bash
docker compose ps -a
```

Expected state:

```text
db        healthy
migrate   exited with code 0
api       healthy
gateway   healthy
```

## Validate readiness

Development:

```bash
curl http://localhost:8099/ready
```

Production local:

```bash
curl http://localhost:8102/ready
```

## Run integration tests

```bash
./scripts/test.sh dev
./scripts/test.sh prod
```

## Run migrations manually

```bash
./scripts/migrate.sh dev
./scripts/migrate.sh prod
```

Migrations must be idempotent.

## Logs

Development:

```bash
docker compose \
  -p devops-compose-day07-dev \
  --env-file env/development.env \
  logs --tail 50
```

Production:

```bash
docker compose \
  -p devops-compose-day07-prod \
  --env-file env/production.env \
  -f compose.yaml \
  -f compose.production.yaml \
  logs --tail 50
```

## Troubleshooting order

```text
config
  ↓
ps -a
  ↓
migration logs
  ↓
database logs
  ↓
API logs
  ↓
gateway logs
  ↓
health and readiness
```

## Database backup

```bash
./scripts/backup.sh dev
./scripts/backup.sh prod
```

Backups are stored in:

```text
backups/
```

Backups are not committed to Git.

## Database restore

```bash
./scripts/restore.sh dev backups/file.sql
./scripts/restore.sh prod backups/file.sql
```

Restore replaces the current lab database state.

Create a new backup before restoring.

## Secret handling

The database password is stored locally in:

```text
secrets/db_password.txt
```

The file must not be committed.

Services receive it at:

```text
/run/secrets/db_password
```

Do not print the secret in logs.

## Database reset

Development:

```bash
./scripts/down.sh dev --volumes
./scripts/up.sh dev
```

Production local:

```bash
./scripts/down.sh prod --volumes
./scripts/up.sh prod
```

Removing the volume permanently deletes the local database.

## Deploying an API change

Rebuild and recreate the API:

```bash
docker compose build api

docker compose up \
  --no-deps \
  -d \
  api
```

Run integration tests after deployment.

## Expected migration state

```sql
SELECT version, applied_at
FROM schema_migrations
ORDER BY applied_at;
```

Expected version:

```text
001-create-items
```