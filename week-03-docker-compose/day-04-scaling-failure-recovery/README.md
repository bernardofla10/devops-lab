# Day 04 - Scaling and Failure Recovery

This lab introduces horizontal scaling, load balancing, restart policies, health checks, failure recovery and container resource limits.

## Architecture

```text
Host
  |
  | localhost:8093
  v
Nginx gateway
  |
  ├── API replica 1
  ├── API replica 2
  └── API replica 3
           |
           v
      PostgreSQL
           |
           v
    Named volume
```

## Main goals

- Scale a stateless API
- Keep PostgreSQL as a single stateful service
- Use Nginx as a gateway
- Avoid fixed host ports on replicated services
- Test automatic container restart
- Simulate application crashes
- Inspect restart counts
- Set CPU, memory and PID limits
- Observe resource usage
- Demonstrate host-port conflicts during scaling

## Prepare environment

```bash
cp .env.example .env
```

## Start

```bash
./scripts/up.sh
```

## Scale

```bash
./scripts/scale.sh 2
./scripts/scale.sh 4
./scripts/scale.sh 3
```

## Test load balancing

```bash
./scripts/load-balancing-test.sh 30
```

## Test failure recovery

```bash
./scripts/failure-recovery-lab.sh
```

## Test resource usage

```bash
./scripts/resource-test.sh
```

## Inspect

```bash
./scripts/inspect.sh
```

## Demonstrate port conflict

Stop the main stack first:

```bash
./scripts/down.sh
```

Run:

```bash
./scripts/port-conflict-lab.sh
```

## Stop while preserving database data

```bash
./scripts/down.sh
```

## Remove all database data

```bash
./scripts/down.sh --volumes
```

## Application endpoints

| Endpoint | Description |
|---|---|
| `/health` | API and database health |
| `/instance` | Identifies the replica |
| `/items` | Lists database items |
| `/items/add?title=example` | Inserts an item |
| `/work?ms=1000` | Generates limited CPU work |
| `/crash` | Exits one API process with code 1 |
| `/error` | Returns an HTTP 500 without exiting |

## Important limitations

This lab scales containers on one Docker host.

It does not provide:

- multi-host high availability
- automatic database replication
- automatic node failover
- production-grade service orchestration