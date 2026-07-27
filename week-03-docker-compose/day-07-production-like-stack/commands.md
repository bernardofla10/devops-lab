# Day 07 - Production-like Docker Compose Stack

## Prepare local configuration

```bash
cp env/development.env.example env/development.env
cp env/production.env.example env/production.env

cp secrets/db_password.example secrets/db_password.txt
chmod 600 secrets/db_password.txt
```

## Validate development

```bash
docker compose \
  -p devops-compose-day07-dev \
  --env-file env/development.env \
  config -q
```

## Validate production

```bash
docker compose \
  -p devops-compose-day07-prod \
  --env-file env/production.env \
  -f compose.yaml \
  -f compose.production.yaml \
  config -q
```

## Start development

```bash
./scripts/up.sh dev
./scripts/up.sh dev --tools
```

## Start production

```bash
./scripts/up.sh prod
```

## Test endpoints

```bash
curl http://localhost:8099/health
curl http://localhost:8099/ready
curl http://localhost:8099/config
curl http://localhost:8099/migrations
curl http://localhost:8099/items
curl "http://localhost:8099/items/add?title=example"
```

## Integration tests

```bash
./scripts/test.sh dev
./scripts/test.sh prod
```

## Migration

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

## Logs

```bash
docker compose logs
docker compose logs db
docker compose logs migrate
docker compose logs api
docker compose logs gateway
```

## Stop

```bash
./scripts/down.sh dev
./scripts/down.sh prod
```

## Remove persistent database

```bash
./scripts/down.sh dev --volumes
./scripts/down.sh prod --volumes
```