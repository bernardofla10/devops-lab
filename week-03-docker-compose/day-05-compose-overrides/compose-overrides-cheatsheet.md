# Docker Compose Overrides Cheatsheet

## Default development merge

```bash
docker compose config
```

Automatically combines:

```text
compose.yaml
compose.override.yaml
```

## Explicit production merge

```bash
docker compose \
  -f compose.yaml \
  -f compose.production.yaml \
  config
```

## File order

```text
first file
  base configuration

second file
  overrides or extends the first
```

## Use another env file

```bash
docker compose \
  --env-file env/development.env \
  config
```

## Development start

```bash
docker compose \
  --env-file env/development.env \
  up -d --build
```

## Production start

```bash
docker compose \
  --env-file env/production.env \
  -f compose.yaml \
  -f compose.production.yaml \
  up -d --build
```

## Compare resolved models

```bash
docker compose \
  --env-file env/development.env \
  config > /tmp/dev.yaml

docker compose \
  --env-file env/production.env \
  -f compose.yaml \
  -f compose.production.yaml \
  config > /tmp/prod.yaml

diff -u /tmp/dev.yaml /tmp/prod.yaml
```

## Common merge behavior

```text
single values
  later value replaces earlier value

environment mappings
  keys are merged
  repeated keys are replaced

command
  later command replaces earlier command

ports and volumes
  follow resource-specific uniqueness rules
```

## Development bind mount

```yaml
services:
  api:
    volumes:
      - ./app/server.js:/app/server.js:ro
```

## Development watch command

```yaml
services:
  api:
    command:
      - node
      - --watch
      - server.js
```

## Production command

```yaml
services:
  api:
    command:
      - node
      - server.js
```

## Production-specific restrictions

```yaml
services:
  api:
    read_only: true
    restart: always
    security_opt:
      - no-new-privileges:true
```

## Critical debugging command

```bash
docker compose config
```

Never assume the final result of a merge without inspecting it.