const http = require("node:http");
const os = require("node:os");

const lodash = require("lodash");

const APP_NAME =
  process.env.APP_NAME ||
  "trivy-security-lab";

const APP_ENV =
  process.env.APP_ENV ||
  "development";

const PORT =
  Number(process.env.PORT || 3000);

function sendJson(response, statusCode, payload) {
  response.writeHead(
    statusCode,
    {
      "Content-Type": "application/json"
    }
  );

  response.end(
    JSON.stringify(payload, null, 2)
  );
}

function createServer() {
  return http.createServer(
    (request, response) => {
      if (request.url === "/health") {
        sendJson(
          response,
          200,
          {
            status: "ok",
            app: APP_NAME,
            environment: APP_ENV,
            hostname: os.hostname()
          }
        );

        return;
      }

      if (request.url === "/chunks") {
        const values = [
          "linux",
          "docker",
          "compose",
          "github-actions",
          "semgrep",
          "trivy"
        ];

        sendJson(
          response,
          200,
          {
            chunks: lodash.chunk(values, 2)
          }
        );

        return;
      }

      if (request.url === "/version") {
        sendJson(
          response,
          200,
          {
            app: APP_NAME,
            nodeVersion: process.version,
            lodashVersion:
              require("lodash/package.json").version
          }
        );

        return;
      }

      sendJson(
        response,
        200,
        {
          message:
            "Trivy dependency and container image scanning lab",

          app: APP_NAME,
          environment: APP_ENV,

          endpoints: [
            "/",
            "/health",
            "/chunks",
            "/version"
          ]
        }
      );
    }
  );
}

if (require.main === module) {
  const server = createServer();

  server.listen(
    PORT,
    "0.0.0.0",
    () => {
      console.log(
        JSON.stringify({
          timestamp:
            new Date().toISOString(),

          message:
            "Server started",

          app:
            APP_NAME,

          environment:
            APP_ENV,

          port:
            PORT
        })
      );
    }
  );

  function shutdown(signal) {
    console.log(
      JSON.stringify({
        timestamp:
          new Date().toISOString(),

        message:
          "Shutdown signal received",

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
  createServer
};