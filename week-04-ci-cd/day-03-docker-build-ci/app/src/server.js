const http = require("node:http");
const os = require("node:os");

const APP_NAME = process.env.APP_NAME || "docker-ci-api";
const APP_ENV = process.env.APP_ENV || "development";
const APP_VERSION = process.env.APP_VERSION || "local";
const APP_REVISION = process.env.APP_REVISION || "unknown";
const PORT = Number(process.env.PORT || 3000);

function sendJson(response, statusCode, payload) {
  response.writeHead(statusCode, {
    "Content-Type": "application/json"
  });

  response.end(JSON.stringify(payload, null, 2));
}

function logRequest(request, statusCode) {
  console.log(
    JSON.stringify({
      timestamp: new Date().toISOString(),
      method: request.method,
      url: request.url,
      statusCode,
      app: APP_NAME,
      environment: APP_ENV,
      hostname: os.hostname()
    })
  );
}

function requestHandler(request, response) {
  if (request.url === "/health") {
    sendJson(response, 200, {
      status: "ok",
      app: APP_NAME,
      environment: APP_ENV,
      hostname: os.hostname()
    });

    logRequest(request, 200);
    return;
  }

  if (request.url === "/version") {
    sendJson(response, 200, {
      app: APP_NAME,
      version: APP_VERSION,
      revision: APP_REVISION,
      nodeVersion: process.version,
      hostname: os.hostname()
    });

    logRequest(request, 200);
    return;
  }

  if (request.url === "/error") {
    console.error(
      JSON.stringify({
        timestamp: new Date().toISOString(),
        level: "error",
        message: "Simulated application error",
        app: APP_NAME,
        hostname: os.hostname()
      })
    );

    sendJson(response, 500, {
      error: "simulated_error",
      message: "Intentional error for CI logging practice."
    });

    logRequest(request, 500);
    return;
  }

  sendJson(response, 200, {
    message: "Docker build in CI lab",
    app: APP_NAME,
    environment: APP_ENV,
    version: APP_VERSION,
    endpoints: [
      "/",
      "/health",
      "/version",
      "/error"
    ]
  });

  logRequest(request, 200);
}

function createServer() {
  return http.createServer(requestHandler);
}

if (require.main === module) {
  const server = createServer();

  server.listen(PORT, "0.0.0.0", () => {
    console.log(
      JSON.stringify({
        timestamp: new Date().toISOString(),
        message: "Server started",
        app: APP_NAME,
        environment: APP_ENV,
        version: APP_VERSION,
        revision: APP_REVISION,
        port: PORT
      })
    );
  });

  function shutdown(signal) {
    console.log(
      JSON.stringify({
        timestamp: new Date().toISOString(),
        message: "Shutdown signal received",
        signal
      })
    );

    server.close(() => {
      process.exit(0);
    });

    setTimeout(() => {
      process.exit(1);
    }, 10000).unref();
  }

  process.on("SIGTERM", () => {
    shutdown("SIGTERM");
  });

  process.on("SIGINT", () => {
    shutdown("SIGINT");
  });
}

module.exports = {
  createServer
};