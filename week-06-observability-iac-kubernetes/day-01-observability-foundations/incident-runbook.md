# Observability Incident Runbook

## Service unavailable

Check container state:

```bash
docker ps -a \
  --filter name=observability-api-day01
```

Check health:

```bash
docker inspect \
  --format '{{.State.Health.Status}}' \
  observability-api-day01
```

Check restart count:

```bash
docker inspect \
  --format '{{.RestartCount}}' \
  observability-api-day01
```

Check application logs:

```bash
docker logs \
  --tail 100 \
  observability-api-day01
```

## Health endpoint failing

```bash
curl -i \
  http://127.0.0.1:18061/live

curl -i \
  http://127.0.0.1:18061/ready

curl -i \
  http://127.0.0.1:18061/health
```

Interpretation:

```text
live=200 ready=503
  application is alive but not ready

live fails
  process or networking problem

health=503
  aggregated health is degraded
```

## Elevated error rate

Inspect logs:

```bash
docker logs \
  observability-api-day01 \
  2>&1 |
jq \
  'select(
    .statusCode >= 500
  )'
```

Inspect metrics:

```bash
curl \
  --silent \
  http://127.0.0.1:18061/metrics |
grep \
  'status_code="500"'
```

## Elevated latency

Inspect slow requests:

```bash
docker logs \
  observability-api-day01 \
  2>&1 |
jq \
  'select(
    .durationMs > 250
  )'
```

Inspect histogram:

```bash
curl \
  --silent \
  http://127.0.0.1:18061/metrics |
grep \
  observability_http_request_duration_seconds
```

## Docker daemon problem

On a systemd host:

```bash
sudo systemctl status docker

sudo journalctl \
  -u docker \
  --since "30 minutes ago"
```

## Recovery

```bash
docker restart \
  observability-api-day01

./scripts/wait-for-health.sh
./scripts/verify-observability.sh
```