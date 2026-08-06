# Day 01 - Observability Foundations

This lab instruments a Node.js application with structured logs,
health endpoints and Prometheus metrics.

## Implemented signals

### Logs

```text
JSON structured logs
request identifiers
status codes
request duration
application version
Git revision
```

### Health

```text
/live
/ready
/health
```

### Metrics

```text
/metrics
```

Metric types:

- counter
- gauge
- histogram

## Start

```bash
./scripts/start-lab.sh
```

## Verify

```bash
./scripts/verify-observability.sh
```

## Inspect logs

```bash
./scripts/inspect-logs.sh
```

## Capture metrics

```bash
./scripts/capture-metrics.sh
```

## Generate traffic

```bash
./scripts/generate-traffic.sh
```

## Simulate incident

```bash
./scripts/simulate-incident.sh
```

## Stop

```bash
./scripts/stop-lab.sh
```

## API

```text
GET /
GET /live
GET /ready
GET /health
GET /metrics
GET /work?delayMs=250
GET /error
```

## Local endpoint

```text
http://127.0.0.1:18061
```

## Evidence

```text
reports/
```