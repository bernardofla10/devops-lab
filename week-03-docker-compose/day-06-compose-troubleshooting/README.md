# Day 06 - Docker Compose Troubleshooting

This lab introduces a structured troubleshooting workflow for Docker Compose applications.

## Healthy architecture

```text
Host
  |
  | localhost:8098
  v
Nginx gateway
  |
  v
Node.js API
  |
  v
PostgreSQL
  |
  v
Named volume
```

## Failures covered

- invalid YAML
- missing required variables
- host port conflicts
- invalid health checks
- incorrect service DNS names
- incorrect database credentials
- stale PostgreSQL volumes

## Diagnostic workflow

```text
docker compose config
  ↓
docker compose ps -a
  ↓
docker compose logs
  ↓
docker inspect
  ↓
docker compose exec or run
  ↓
network and volume inspection
```

## Start healthy stack

```bash
./scripts/up.sh
```

## Generate diagnostic report

```bash
./scripts/diagnose.sh
```

## Observe events

```bash
./scripts/events.sh
```

## Configuration failure labs

```bash
./scripts/yaml-error-lab.sh
./scripts/missing-variable-lab.sh
```

## Runtime failure labs

```bash
./scripts/port-conflict-lab.sh
./scripts/healthcheck-lab.sh
./scripts/dns-lab.sh
./scripts/credentials-lab.sh
./scripts/stale-volume-lab.sh
```

## Stop stack

```bash
./scripts/down.sh
```

Remove persistent data:

```bash
./scripts/down.sh --volumes
```

## Main lesson

Do not start troubleshooting by randomly restarting containers.

First gather evidence:

- effective configuration
- service status
- exit codes
- healthcheck output
- logs
- DNS resolution
- connectivity
- mounts and volumes