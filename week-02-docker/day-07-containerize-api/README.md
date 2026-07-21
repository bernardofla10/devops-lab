# Day 07 - Containerized API Final Lab

This is the final Docker Fundamentals lab for **Week 02**.

The goal is to containerize a simple API using:

- Dockerfile
- Port mapping
- Environment variables
- Logs
- Named volumes
- Docker networks
- Health checks
- Helper scripts

---

## Application Endpoints

| Endpoint | Description |
|----------|-------------|
| `/` | API information |
| `/health` | Health check |
| `/config` | Runtime configuration |
| `/items` | List persisted items |
| `/items/add?title=example` | Add an item to persistent storage |
| `/error` | Simulate an error for logging practice |

---

## Build

```bash
./scripts/build.sh
```

---

## Run

```bash
./scripts/run.sh
```

The API will be available at:

```text
http://localhost:8088
```

---

## Test

```bash
./scripts/test.sh
```

---

## View Logs

```bash
./scripts/logs.sh
```

---

## Inspect the Container

```bash
./scripts/inspect.sh
```

---

## Test Volume Persistence

```bash
./scripts/volume-lab.sh
```

---

## Test Docker Networking

```bash
./scripts/network-lab.sh
```

---

## Cleanup

```bash
./scripts/cleanup.sh
```

To remove the persistent Docker volume:

```bash
docker volume rm devops-api-data-day07
```

---

## Key Docker Concepts Practiced

- Image build
- Container lifecycle
- Port mapping
- Environment variables
- `.env.example`
- Named volumes
- Docker networks
- Container logs
- `docker exec`
- `docker inspect`
- Health checks