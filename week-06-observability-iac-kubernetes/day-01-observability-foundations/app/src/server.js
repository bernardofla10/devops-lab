const crypto = require("node:crypto");
const http = require("node:http");
const os = require("node:os");

const {
  performance
} = require("node:perf_hooks");

const {
  URL
} = require("node:url");

const HISTOGRAM_BUCKETS = [
  0.005,
  0.01,
  0.025,
  0.05,
  0.1,
  0.25,
  0.5,
  1,
  2.5,
  5
];

function parseNonNegativeNumber(
  rawValue,
  defaultValue
) {
  const parsedValue =
    Number(rawValue);

  if (
    !Number.isFinite(parsedValue) ||
    parsedValue < 0
  ) {
    return defaultValue;
  }

  return parsedValue;
}

function escapeLabelValue(value) {
  return String(value)
    .replaceAll("\\", "\\\\")
    .replaceAll("\n", "\\n")
    .replaceAll('"', '\\"');
}

function formatLabels(labels) {
  const entries =
    Object.entries(labels);

  if (entries.length === 0) {
    return "";
  }

  const formatted =
    entries
      .map(
        ([key, value]) =>
          `${key}="${escapeLabelValue(value)}"`
      )
      .join(",");

  return `{${formatted}}`;
}

function normalizeRoute(pathname) {
  const knownRoutes =
    new Set([
      "/",
      "/live",
      "/ready",
      "/health",
      "/metrics",
      "/work",
      "/error"
    ]);

  if (knownRoutes.has(pathname)) {
    return pathname;
  }

  return "unknown";
}

function resolveRequestId(request) {
  const candidate =
    request.headers["x-request-id"];

  if (
    typeof candidate === "string" &&
    /^[A-Za-z0-9._-]{1,100}$/.test(candidate)
  ) {
    return candidate;
  }

  return crypto.randomUUID();
}

function writeLog(
  metadata,
  level,
  message,
  fields = {}
) {
  const payload = {
    timestamp:
      new Date().toISOString(),

    level,
    message,

    app:
      metadata.appName,

    environment:
      metadata.environment,

    version:
      metadata.version,

    revision:
      metadata.revision,

    hostname:
      os.hostname(),

    ...fields
  };

  const serialized =
    JSON.stringify(payload);

  if (level === "error") {
    console.error(serialized);
    return;
  }

  console.log(serialized);
}

function createMetricsState() {
  return {
    startedAt:
      Date.now(),

    inflightRequests:
      0,

    requestTotals:
      new Map(),

    durationHistograms:
      new Map()
  };
}

function createMetricKey({
  method,
  route,
  statusCode
}) {
  return [
    method,
    route,
    String(statusCode)
  ].join("|");
}

function recordRequest(
  metrics,
  {
    method,
    route,
    statusCode,
    durationSeconds
  }
) {
  const key =
    createMetricKey({
      method,
      route,
      statusCode
    });

  const labels = {
    method,
    route,
    status_code:
      String(statusCode)
  };

  const currentTotal =
    metrics.requestTotals.get(key);

  if (currentTotal) {
    currentTotal.value += 1;
  } else {
    metrics.requestTotals.set(
      key,
      {
        labels,
        value: 1
      }
    );
  }

  let histogram =
    metrics.durationHistograms.get(key);

  if (!histogram) {
    histogram = {
      labels,
      count: 0,
      sum: 0,
      buckets:
        HISTOGRAM_BUCKETS.map(
          (upperBound) => ({
            upperBound,
            count: 0
          })
        )
    };

    metrics.durationHistograms.set(
      key,
      histogram
    );
  }

  histogram.count += 1;
  histogram.sum += durationSeconds;

  for (
    const bucket
    of histogram.buckets
  ) {
    if (
      durationSeconds <=
      bucket.upperBound
    ) {
      bucket.count += 1;
    }
  }
}

function renderMetrics(
  metrics,
  metadata,
  ready
) {
  const lines = [];

  lines.push(
    "# HELP observability_app_info Static application information."
  );

  lines.push(
    "# TYPE observability_app_info gauge"
  );

  lines.push(
    "observability_app_info" +
    formatLabels({
      app:
        metadata.appName,

      environment:
        metadata.environment,

      version:
        metadata.version,

      revision:
        metadata.revision
    }) +
    " 1"
  );

  lines.push(
    "# HELP observability_app_ready Whether the application is ready to receive traffic."
  );

  lines.push(
    "# TYPE observability_app_ready gauge"
  );

  lines.push(
    `observability_app_ready ${ready ? 1 : 0}`
  );

  lines.push(
    "# HELP observability_uptime_seconds Process uptime in seconds."
  );

  lines.push(
    "# TYPE observability_uptime_seconds gauge"
  );

  lines.push(
    `observability_uptime_seconds ${
      (
        Date.now() -
        metrics.startedAt
      ) / 1000
    }`
  );

  lines.push(
    "# HELP observability_inflight_requests Current number of HTTP requests being processed."
  );

  lines.push(
    "# TYPE observability_inflight_requests gauge"
  );

  lines.push(
    `observability_inflight_requests ${metrics.inflightRequests}`
  );

  lines.push(
    "# HELP observability_process_resident_memory_bytes Resident memory used by the Node.js process."
  );

  lines.push(
    "# TYPE observability_process_resident_memory_bytes gauge"
  );

  lines.push(
    `observability_process_resident_memory_bytes ${
      process.memoryUsage().rss
    }`
  );

  lines.push(
    "# HELP observability_http_requests_total Total number of completed HTTP requests."
  );

  lines.push(
    "# TYPE observability_http_requests_total counter"
  );

  for (
    const requestTotal
    of metrics.requestTotals.values()
  ) {
    lines.push(
      "observability_http_requests_total" +
      formatLabels(
        requestTotal.labels
      ) +
      ` ${requestTotal.value}`
    );
  }

  lines.push(
    "# HELP observability_http_request_duration_seconds HTTP request duration histogram."
  );

  lines.push(
    "# TYPE observability_http_request_duration_seconds histogram"
  );

  for (
    const histogram
    of metrics.durationHistograms.values()
  ) {
    for (
      const bucket
      of histogram.buckets
    ) {
      lines.push(
        "observability_http_request_duration_seconds_bucket" +
        formatLabels({
          ...histogram.labels,
          le:
            String(
              bucket.upperBound
            )
        }) +
        ` ${bucket.count}`
      );
    }

    lines.push(
      "observability_http_request_duration_seconds_bucket" +
      formatLabels({
        ...histogram.labels,
        le: "+Inf"
      }) +
      ` ${histogram.count}`
    );

    lines.push(
      "observability_http_request_duration_seconds_sum" +
      formatLabels(
        histogram.labels
      ) +
      ` ${histogram.sum}`
    );

    lines.push(
      "observability_http_request_duration_seconds_count" +
      formatLabels(
        histogram.labels
      ) +
      ` ${histogram.count}`
    );
  }

  return `${lines.join("\n")}\n`;
}

function sendJson(
  response,
  statusCode,
  payload
) {
  response.writeHead(
    statusCode,
    {
      "Content-Type":
        "application/json; charset=utf-8",

      "X-Content-Type-Options":
        "nosniff"
    }
  );

  response.end(
    JSON.stringify(
      payload,
      null,
      2
    )
  );
}

function sendMetrics(
  response,
  payload
) {
  response.writeHead(
    200,
    {
      "Content-Type":
        "text/plain; version=0.0.4; charset=utf-8",

      "Cache-Control":
        "no-store",

      "X-Content-Type-Options":
        "nosniff"
    }
  );

  response.end(payload);
}

function createApplication(
  options = {}
) {
  const metadata = {
    appName:
      options.appName ||
      process.env.APP_NAME ||
      "observability-foundations-api",

    environment:
      options.environment ||
      process.env.APP_ENV ||
      "development",

    version:
      options.version ||
      process.env.APP_VERSION ||
      "local",

    revision:
      options.revision ||
      process.env.APP_REVISION ||
      "unknown"
  };

  const startupDelayMs =
    options.startupDelayMs ??
    parseNonNegativeNumber(
      process.env.STARTUP_DELAY_MS,
      3000
    );

  const metrics =
    createMetricsState();

  let ready =
    startupDelayMs === 0;

  if (!ready) {
    const readinessTimer =
      setTimeout(() => {
        ready = true;

        writeLog(
          metadata,
          "info",
          "application_ready",
          {
            startupDelayMs
          }
        );
      }, startupDelayMs);

    readinessTimer.unref();
  }

  const server =
    http.createServer(
      async (
        request,
        response
      ) => {
        const requestStartedAt =
          performance.now();

        const requestId =
          resolveRequestId(request);

        const url =
          new URL(
            request.url,
            `http://${
              request.headers.host ||
              "localhost"
            }`
          );

        const route =
          normalizeRoute(
            url.pathname
          );

        metrics.inflightRequests += 1;

        response.setHeader(
          "X-Request-ID",
          requestId
        );

        response.on(
          "finish",
          () => {
            metrics.inflightRequests -= 1;

            const durationSeconds =
              (
                performance.now() -
                requestStartedAt
              ) / 1000;

            recordRequest(
              metrics,
              {
                method:
                  request.method,

                route,

                statusCode:
                  response.statusCode,

                durationSeconds
              }
            );

            writeLog(
              metadata,
              response.statusCode >= 500
                ? "error"
                : "info",

              "request_completed",

              {
                requestId,

                method:
                  request.method,

                route,

                statusCode:
                  response.statusCode,

                durationMs:
                  Number(
                    (
                      durationSeconds *
                      1000
                    ).toFixed(3)
                  ),

                userAgent:
                  request.headers[
                    "user-agent"
                  ] || "unknown"
              }
            );
          }
        );

        if (
          request.method !== "GET"
        ) {
          sendJson(
            response,
            405,
            {
              error:
                "method_not_allowed",

              requestId
            }
          );

          return;
        }

        if (
          url.pathname === "/live"
        ) {
          sendJson(
            response,
            200,
            {
              status:
                "alive",

              app:
                metadata.appName,

              requestId
            }
          );

          return;
        }

        if (
          url.pathname === "/ready"
        ) {
          sendJson(
            response,
            ready ? 200 : 503,
            {
              status:
                ready
                  ? "ready"
                  : "not_ready",

              app:
                metadata.appName,

              requestId
            }
          );

          return;
        }

        if (
          url.pathname === "/health"
        ) {
          sendJson(
            response,
            ready ? 200 : 503,
            {
              status:
                ready
                  ? "ok"
                  : "degraded",

              app:
                metadata.appName,

              checks: {
                live:
                  true,

                ready
              },

              uptimeSeconds:
                (
                  Date.now() -
                  metrics.startedAt
                ) / 1000,

              requestId
            }
          );

          return;
        }

        if (
          url.pathname === "/metrics"
        ) {
          sendMetrics(
            response,
            renderMetrics(
              metrics,
              metadata,
              ready
            )
          );

          return;
        }

        if (
          url.pathname === "/work"
        ) {
          const requestedDelay =
            parseNonNegativeNumber(
              url.searchParams.get(
                "delayMs"
              ),
              100
            );

          const delayMs =
            Math.min(
              requestedDelay,
              2000
            );

          await new Promise(
            (resolve) => {
              setTimeout(
                resolve,
                delayMs
              );
            }
          );

          sendJson(
            response,
            200,
            {
              status:
                "completed",

              delayMs,

              requestId
            }
          );

          return;
        }

        if (
          url.pathname === "/error"
        ) {
          sendJson(
            response,
            500,
            {
              error:
                "simulated_error",

              message:
                "Intentional error for observability practice.",

              requestId
            }
          );

          return;
        }

        if (
          url.pathname === "/"
        ) {
          sendJson(
            response,
            200,
            {
              app:
                metadata.appName,

              environment:
                metadata.environment,

              version:
                metadata.version,

              revision:
                metadata.revision,

              message:
                "Observability foundations lab",

              endpoints: [
                "/",
                "/live",
                "/ready",
                "/health",
                "/metrics",
                "/work?delayMs=250",
                "/error"
              ],

              requestId
            }
          );

          return;
        }

        sendJson(
          response,
          404,
          {
            error:
              "not_found",

            route:
              "unknown",

            requestId
          }
        );
      }
    );

  return {
    server,

    getReady() {
      return ready;
    },

    markNotReady() {
      ready = false;
    }
  };
}

if (require.main === module) {
  const port =
    Number(
      process.env.PORT ||
      3000
    );

  const application =
    createApplication();

  application.server.listen(
    port,
    "0.0.0.0",
    () => {
      writeLog(
        {
          appName:
            process.env.APP_NAME ||
            "observability-foundations-api",

          environment:
            process.env.APP_ENV ||
            "development",

          version:
            process.env.APP_VERSION ||
            "local",

          revision:
            process.env.APP_REVISION ||
            "unknown"
        },

        "info",
        "server_started",
        {
          port
        }
      );
    }
  );

  function shutdown(signal) {
    application.markNotReady();

    writeLog(
      {
        appName:
          process.env.APP_NAME ||
          "observability-foundations-api",

        environment:
          process.env.APP_ENV ||
          "development",

        version:
          process.env.APP_VERSION ||
          "local",

        revision:
          process.env.APP_REVISION ||
          "unknown"
      },

      "info",
      "shutdown_started",
      {
        signal
      }
    );

    application.server.close(
      () => {
        process.exit(0);
      }
    );

    setTimeout(
      () => {
        process.exit(1);
      },
      10000
    ).unref();
  }

  process.on(
    "SIGTERM",
    () => shutdown("SIGTERM")
  );

  process.on(
    "SIGINT",
    () => shutdown("SIGINT")
  );
}

module.exports = {
  createApplication,
  normalizeRoute,
  renderMetrics
};