# Day 03 - Adminer and Compose Network Isolation

This lab extends the API and PostgreSQL stack with:

- Adminer
- Docker Compose profiles
- a public application network
- a private database network
- selective port publishing
- container DNS and network-isolation tests

## Architecture

```text
Host
  |
  ├── localhost:8091 -> API
  |
  └── localhost:8092 -> Adminer

API
  ├── public-net
  └── private-net

Adminer
  ├── public-net
  └── private-net

PostgreSQL
  └── private-net
```

## Network membership

| Service | public-net | private-net |
|---|---:|---:|
| API | Yes | Yes |
| Adminer | Yes | Yes |
| PostgreSQL | No | Yes |

## Prepare environment

```bash
cp .env.example .env
```

## Start all services

```bash
./scripts/up.sh
```

## Start only API and PostgreSQL

```bash
./scripts/up.sh --core
```

## Activate Adminer manually

```bash
docker compose --profile tools up -d adminer
```

## Application URLs

```text
API:     http://localhost:8091
Adminer: http://localhost:8092
```

## Adminer credentials

```text
System:   PostgreSQL
Server:   db
Username: devops
Password: value from POSTGRES_PASSWORD in .env
Database: devopsdb
```

## Test

```bash
./scripts/test.sh
```

## Inspect services and networks

```bash
./scripts/inspect.sh
```

## Test network isolation

```bash
./scripts/network-test.sh
```

## Open PostgreSQL shell

```bash
./scripts/db-shell.sh
```

## Stop while preserving database data

```bash
./scripts/down.sh
```

## Remove all database data

```bash
./scripts/down.sh --volumes
```

## Main lessons

- Services communicate only when they share a network.
- PostgreSQL does not need a published host port.
- API and Adminer reach PostgreSQL through `db:5432`.
- `localhost` inside a container refers to that container.
- Profiles allow optional tools to remain disabled by default.
- `internal: true` creates an externally isolated network.
- Adminer should be treated as a development or administration tool.