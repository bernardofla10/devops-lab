# Day 02 - Docker Compose with API and PostgreSQL

## Prepare environment

```bash
cp .env.example .env
```

## Generate package lock

```bash
docker run --rm \
  -v "$PWD/app:/app" \
  -w /app \
  node:20-alpine \
  npm install --package-lock-only
```

## Validate Compose

```bash
docker compose config
docker compose config --services
docker compose config --images
```

## Build and start

```bash
docker compose up -d --build
```

## Check services

```bash
docker compose ps
docker compose images
docker compose top
```

## Test API

```bash
curl http://localhost:8090
curl http://localhost:8090/health
curl http://localhost:8090/config
curl http://localhost:8090/db-info
curl http://localhost:8090/items
curl "http://localhost:8090/items/add?title=first-postgres-compose-item"
curl "http://localhost:8090/items/add?title=second-postgres-compose-item"
curl http://localhost:8090/items
curl http://localhost:8090/error
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

## PostgreSQL shell

```bash
docker compose exec db \
  psql -U devops -d devopsdb
```

Inside psql:

```sql
\dt
\d items
SELECT * FROM items ORDER BY id;
SELECT current_database();
SELECT current_user;
\q
```

## API shell

```bash
docker compose exec api sh
```

Inside the API:

```sh
printenv DB_HOST
printenv DB_PORT
printenv DB_NAME
printenv DB_USER

node -e "require('dns').lookup('db', (error, address) => console.log(error || address))"

exit
```

## Inspect resources

```bash
docker network ls | grep devops-compose-day02
docker network inspect devops-compose-day02_default

docker volume ls | grep devops-compose-day02
docker volume inspect devops-compose-day02_postgres-data

docker inspect "$(docker compose ps -q api)"
docker inspect "$(docker compose ps -q db)"
```

## Stop database

```bash
docker compose stop db
docker compose logs --tail 30 api
docker compose start db
docker compose restart api
```

## Preserve database

```bash
docker compose down
docker compose up -d
```

## Remove database

```bash
docker compose down -v
docker compose up -d
```

## Helper scripts

```bash
chmod +x scripts/*.sh

./scripts/up.sh
./scripts/test.sh
./scripts/inspect.sh
./scripts/db-shell.sh
./scripts/down.sh
./scripts/down.sh --volumes
./scripts/reset-db.sh --confirm
```