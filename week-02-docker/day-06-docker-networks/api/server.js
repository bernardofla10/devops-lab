const http = require("http");
const os = require("os");

const APP_NAME = process.env.APP_NAME || "docker-network-api";
const APP_ENV = process.env.APP_ENV || "development";
const PORT = Number(process.env.PORT || 3000);

function sendJson(res, statusCode, payload) {
  res.writeHead(statusCode, { "Content-Type": "application/json" });
  res.end(JSON.stringify(payload, null, 2));
}

function logRequest(req, statusCode) {
  console.log(
    JSON.stringify({
      timestamp: new Date().toISOString(),
      method: req.method,
      url: req.url,
      statusCode,
      app: APP_NAME,
      env: APP_ENV,
      hostname: os.hostname()
    })
  );
}

const server = http.createServer((req, res) => {
  if (req.url === "/health") {
    sendJson(res, 200, {
      status: "ok",
      app: APP_NAME,
      env: APP_ENV,
      hostname: os.hostname()
    });
    logRequest(req, 200);
    return;
  }

  if (req.url === "/info") {
    sendJson(res, 200, {
      app: APP_NAME,
      env: APP_ENV,
      hostname: os.hostname(),
      port: PORT,
      message: "API reached successfully through Docker networking"
    });
    logRequest(req, 200);
    return;
  }

  sendJson(res, 200, {
    app: APP_NAME,
    env: APP_ENV,
    hostname: os.hostname(),
    endpoints: ["/", "/health", "/info"]
  });
  logRequest(req, 200);
});

server.listen(PORT, "0.0.0.0", () => {
  console.log(
    JSON.stringify({
      timestamp: new Date().toISOString(),
      message: "API server started",
      app: APP_NAME,
      env: APP_ENV,
      port: PORT,
      hostname: os.hostname()
    })
  );
});