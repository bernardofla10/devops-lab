# Observability Signal Mapping

## Application startup

Log:

```text
server_started
application_ready
```

Metric:

```text
observability_app_ready
observability_uptime_seconds
```

## Successful request

Log:

```text
request_completed
statusCode=200
durationMs
requestId
```

Metrics:

```text
observability_http_requests_total
observability_http_request_duration_seconds
```

## Application error

Log:

```text
request_completed
level=error
statusCode=500
```

Metric:

```text
observability_http_requests_total{
  status_code="500"
}
```

## Slow request

Log:

```text
durationMs > threshold
```

Metric:

```text
observability_http_request_duration_seconds_bucket
```

## Process crash

Docker:

```text
container exited
restart count increased
new StartedAt timestamp
```

Application logs:

```text
server_started after restart
```

Metrics:

```text
counters reset
uptime resets
```

## Readiness problem

Endpoint:

```text
/ready -> HTTP 503
```

Metric:

```text
observability_app_ready 0
```

The process can remain alive while readiness is false.