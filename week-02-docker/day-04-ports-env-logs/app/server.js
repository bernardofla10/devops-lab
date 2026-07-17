const http = require("http");

const APP_NAME = process.env.APP_NAME || "docker-env-logs-demo";
const APP_ENV = process.env.APP_ENV || "development";
const APP_MESSAGE = process.env.APP_MESSAGE || "Hello from Docker";
const PORT = Number(process.env.PORT || 3000);

function logRequest(req, statusCode) {
  const timestamp = new Date().toISOString();
  console.log(
    JSON.stringify({
      timestamp,
      method: req.method,
      url: req.url,
      statusCode,
      appName: APP_NAME,
      appEnv: APP_ENV,
    })
  );
}

const server = http.createServer((req, res) => {
  if (req.url === "/health") {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(
      JSON.stringify({
        status: "ok",
        app: APP_NAME,
        env: APP_ENV,
      })
    );
    logRequest(req, 200);
    return;
  }

  if (req.url === "/config") {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(
      JSON.stringify({
        appName: APP_NAME,
        appEnv: APP_ENV,
        appMessage: APP_MESSAGE,
        port: PORT,
      })
    );
    logRequest(req, 200);
    return;
  }

  if (req.url === "/error") {
    console.error(
      JSON.stringify({
        timestamp: new Date().toISOString(),
        level: "error",
        message: "Simulated application error",
      })
    );

    res.writeHead(500, { "Content-Type": "application/json" });
    res.end(
      JSON.stringify({
        error: "simulated_error",
        message: "This is a simulated error for logging practice.",
      })
    );
    logRequest(req, 500);
    return;
  }

  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(
    JSON.stringify({
      message: APP_MESSAGE,
      app: APP_NAME,
      env: APP_ENV,
      endpoints: ["/", "/health", "/config", "/error"],
    })
  );
  logRequest(req, 200);
});

server.listen(PORT, "0.0.0.0", () => {
  console.log(
    JSON.stringify({
      timestamp: new Date().toISOString(),
      message: "Server started",
      app: APP_NAME,
      env: APP_ENV,
      port: PORT,
    })
  );
});