# Day 05 - Compose Overrides and Environment Configuration

## Create local environment files

```bash
cp env/development.env.example env/development.env
cp env/production.env.example env/production.env
```

## Validate development

```bash
docker compose \
  -p devops-compose-day05-dev \
  --env-file env/development.env \
  config
```

## Validate production

```bash
docker compose \
  -p devops-compose-day05-prod \
  --env-file env/production.env \
  -f compose.yaml \
  -f compose.production.yaml \
  config
```

## Compare configurations

```bash
docker compose \
  -p devops-compose-day05-dev \
  --env-file env/development.env \
  config > /tmp/day05-development.yaml

docker compose \
  -p devops-compose-day05-prod \
  --env-file env/production.env \
  -f compose.yaml \
  -f compose.production.yaml \
  config > /tmp/day05-production.yaml

diff -u \
  /tmp/day05-development.yaml \
  /tmp/day05-production.yaml
```

## Start development

```bash
docker compose \
  -p devops-compose-day05-dev \
  --env-file env/development.env \
  up -d --build
```

## Start production

```bash
docker compose \
  -p devops-compose-day05-prod \
  --env-file env/production.env \
  -f compose.yaml \
  -f compose.production.yaml \
  up -d --build
```

## Development tests

```bash
curl http://localhost:8095/health
curl http://localhost:8095/config
curl http://localhost:8096/health
```

## Production tests

```bash
curl http://localhost:8097/health
curl http://localhost:8097/config
```

## Redeploy production API

```bash
docker compose \
  -p devops-compose-day05-prod \
  --env-file env/production.env \
  -f compose.yaml \
  -f compose.production.yaml \
  build api

docker compose \
  -p devops-compose-day05-prod \
  --env-file env/production.env \
  -f compose.yaml \
  -f compose.production.yaml \
  up --no-deps -d api
```

## Helper scripts

```bash
chmod +x scripts/*.sh

./scripts/config-dev.sh
./scripts/config-prod.sh

./scripts/up-dev.sh
./scripts/test.sh dev
./scripts/inspect.sh dev
./scripts/down.sh dev

./scripts/up-prod.sh
./scripts/test.sh prod
./scripts/inspect.sh prod
./scripts/redeploy-api.sh
./scripts/down.sh prod
```