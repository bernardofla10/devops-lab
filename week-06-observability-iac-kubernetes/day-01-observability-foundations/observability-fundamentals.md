# Observability Fundamentals

## Observability

Observability is the ability to understand a system's internal
behavior using the signals it emits.

## Main signals

```text
logs
metrics
traces
```

## Logs

Logs represent individual events.

Examples:

- application startup
- completed request
- failed request
- shutdown
- dependency error

Good logs include:

- timestamp
- severity
- event name
- application
- environment
- version
- revision
- request ID
- route
- status
- duration

## Metrics

Metrics are numerical measurements collected over time.

The application exposes:

```text
request counters
readiness gauge
in-flight request gauge
memory gauge
uptime gauge
latency histogram
```

## Traces

A trace follows a request through multiple components.

This lab documents traces conceptually but does not implement
distributed tracing yet.

## Health endpoints

```text
/live
  process is alive

/ready
  application can receive traffic

/health
  aggregated operational state
```

## Prometheus metrics

```text
/metrics
```

Content type:

```text
text/plain; version=0.0.4
```

## Cardinality

Use bounded labels:

```text
method
route
status_code
environment
```

Avoid unbounded labels:

```text
request_id
user_id
email
full URL
timestamp
```

## Operational question

```text
How do I know that my service is down?
```

Possible evidence:

- failed health request
- Docker health becomes unhealthy
- container state changes
- restart count increases
- error rate increases
- request traffic disappears
- latency increases