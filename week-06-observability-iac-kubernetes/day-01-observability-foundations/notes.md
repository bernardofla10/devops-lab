# Day 01 - Observability Foundations

## Goal

Instrument and operate a small service before introducing Prometheus
Server and Grafana.

## Logs

The application emits one JSON object per event.

Logs include:

- event timestamp
- severity
- request ID
- HTTP route
- status code
- duration
- version
- revision

## Metrics

The application exposes Prometheus text format at:

```text
/metrics
```

## Counter

```text
observability_http_requests_total
```

The counter grows and resets when the process restarts.

## Gauge

Examples:

```text
observability_app_ready
observability_inflight_requests
observability_process_resident_memory_bytes
```

Gauges can increase and decrease.

## Histogram

```text
observability_http_request_duration_seconds
```

The histogram records request-duration observations in cumulative
buckets.

## Health

```text
/live
  process is alive

/ready
  application can receive traffic

/health
  aggregated operational state
```

## Cardinality

The application uses normalized route labels.

Query parameters and request IDs are not metric labels.

## Docker

Application logs are written to stdout and stderr.

Docker captures those streams.

The Compose file limits local log-file growth.

## Incident exercise

An HTTP 500 did not stop the process.

A SIGKILL terminated the process.

Docker restarted the container because of its restart policy.

## Important lessons

- Logs, metrics and traces solve different problems.
- Structured logs are easier to filter and aggregate.
- Liveness and readiness are different signals.
- Running does not mean healthy.
- An HTTP error does not necessarily mean the process is down.
- Counters reset after process restarts.
- Metric labels must have bounded cardinality.
- Healthchecks enable automated failure detection.
- Restart policies provide recovery but not root-cause analysis.
- Instrumentation must exist before an incident occurs.

## Next step

Run Prometheus Server and configure it to scrape the application's
metrics endpoint.