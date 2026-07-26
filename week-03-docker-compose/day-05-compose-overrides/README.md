# Day 05 - Docker Compose Overrides

This lab demonstrates how to use a common Compose configuration with environment-specific overrides.

## Files

```text
compose.yaml
  common configuration

compose.override.yaml
  automatically loaded development configuration

compose.production.yaml
  explicitly loaded production configuration
```

## Environments

### Development

Development includes:

- source-code bind mount
- Node.js watch mode
- direct API host port
- direct PostgreSQL host port
- disabled restart policies

### Production

Production includes:

- code packaged inside the image
- no direct API port
- no direct PostgreSQL port
- resource limits
- restart policies
- read-only API filesystem
- internal backend network

## Prepare local environment files

```bash
cp env/development.env.example env/development.env
cp env/production.env.example env/production.env
```

## Validate development configuration

```bash
./scripts/config-dev.sh
```

## Validate production configuration

```bash
./scripts/config-prod.sh
```

## Start development

```bash
./scripts/up-dev.sh
```

URLs:

```text
Gateway:    http://localhost:8095
Direct API: http://localhost:8096
PostgreSQL: localhost:5433
```

## Start production locally

```bash
./scripts/up-prod.sh
```

URL:

```text
http://localhost:8097
```

## Test

```bash
./scripts/test.sh dev
./scripts/test.sh prod
```

## Inspect

```bash
./scripts/inspect.sh dev
./scripts/inspect.sh prod
```

## Redeploy production API

```bash
./scripts/redeploy-api.sh
```

## Stop

```bash
./scripts/down.sh dev
./scripts/down.sh prod
```

Remove persistent data:

```bash
./scripts/down.sh dev --volumes
./scripts/down.sh prod --volumes
```

## Important rules

- Files are merged in the order passed with `-f`.
- `compose.override.yaml` is automatically used in the default workflow.
- Production explicitly uses only `compose.yaml` and `compose.production.yaml`.
- Paths in override files are resolved relative to the base Compose file.
- Always inspect the merged model with `docker compose config`.