const http = require("node:http");
const os = require("node:os");
const { URL } = require("node:url");

const APP_NAME =
  process.env.APP_NAME ||
  "final-devsecops-api";

const APP_ENV =
  process.env.APP_ENV ||
  "development";

const APP_VERSION =
  process.env.APP_VERSION ||
  "local";

const APP_REVISION =
  process.env.APP_REVISION ||
  "unknown";

const PORT =
  Number(process.env.PORT || 3000);

function sendJson(response, statusCode, payload) {
  response.writeHead(
    statusCode,
    {
      "Content-Type": "application/json",
      "X-Content-Type-Options": "nosniff"
    }
  );

  response.end(
    JSON.stringify(payload, null, 2)
  );
}

function validateMessage(rawMessage) {
  if (typeof rawMessage !== "string") {
    throw new TypeError(
      "message must be a string"
    );
  }

  const normalizedMessage =
    rawMessage.trim();

  if (normalizedMessage.length === 0) {
    throw new RangeError(
      "message must not be empty"
    );
  }

  if (normalizedMessage.length > 100) {
    throw new RangeError(
      "message must not exceed 100 characters"
    );
  }

  return normalizedMessage;
}

function createServer() {
  return http.createServer(
    (request, response) => {
      const url = new URL(
        request.url,
        `http://${request.headers.host}`
      );

      if (url.pathname === "/health") {
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

      if (url.pathname === "/ready") {
        sendJson(
          response,
          200,
          {
            status: "ready",
            app: APP_NAME,
            hostname: os.hostname()
          }
        );

        return;
      }

      if (url.pathname === "/version") {
        sendJson(
          response,
          200,
          {
            app: APP_NAME,
            version: APP_VERSION,
            revision: APP_REVISION,
            nodeVersion: process.version,
            hostname: os.hostname()
          }
        );

        return;
      }

      if (url.pathname === "/echo") {
        try {
          const message =
            validateMessage(
              url.searchParams.get("message") || ""
            );

          sendJson(
            response,
            200,
            {
              message,
              length: message.length
            }
          );
        } catch (error) {
          sendJson(
            response,
            400,
            {
              error: "invalid_message",
              message: error.message
            }
          );
        }

        return;
      }

      if (url.pathname === "/error") {
        console.error(
          JSON.stringify({
            timestamp:
              new Date().toISOString(),

            level:
              "error",

            message:
              "Intentional application error",

            app:
              APP_NAME,

            hostname:
              os.hostname()
          })
        );

        sendJson(
          response,
          500,
          {
            error: "simulated_error",
            message:
              "Intentional error for pipeline diagnostics."
          }
        );

        return;
      }

      sendJson(
        response,
        200,
        {
          app: APP_NAME,
          environment: APP_ENV,
          version: APP_VERSION,
          revision: APP_REVISION,
          message:
            "Final CI/CD and DevSecOps pipeline",

          endpoints: [
            "/",
            "/health",
            "/ready",
            "/version",
            "/echo?message=hello",
            "/error"
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

          version:
            APP_VERSION,

          revision:
            APP_REVISION,

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
  createServer,
  validateMessage
};