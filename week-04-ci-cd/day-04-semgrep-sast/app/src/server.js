const http = require("node:http");
const os = require("node:os");
const { URL } = require("node:url");

const {
  runOperation
} = require("./command-runner");

const APP_NAME = process.env.APP_NAME || "semgrep-sast-lab";
const APP_ENV = process.env.APP_ENV || "development";
const PORT = Number(process.env.PORT || 3000);

function sendJson(response, statusCode, payload) {
  response.writeHead(
    statusCode,
    {
      "Content-Type": "application/json"
    }
  );

  response.end(JSON.stringify(payload, null, 2));
}

function createServer() {
  return http.createServer((request, response) => {
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

    if (url.pathname === "/run") {
      const operation =
        url.searchParams.get("operation") ||
        "node-version";

      runOperation(
        operation,
        (error, result) => {
          if (error) {
            const statusCode =
              error.code === "OPERATION_NOT_ALLOWED"
                ? 400
                : 500;

            sendJson(
              response,
              statusCode,
              {
                error:
                  error.code === "OPERATION_NOT_ALLOWED"
                    ? "operation_not_allowed"
                    : "operation_failed",
                message: error.message
              }
            );

            return;
          }

          sendJson(
            response,
            200,
            {
              operation,
              stdout: result.stdout,
              stderr: result.stderr
            }
          );
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
        message: "Semgrep SAST security gate lab",
        endpoints: [
          "/",
          "/health",
          "/run?operation=node-version"
        ]
      }
    );

    return;
  });
}

if (require.main === module) {
  const server = createServer();

  server.listen(
    PORT,
    "0.0.0.0",
    () => {
      console.log(
        JSON.stringify({
          timestamp: new Date().toISOString(),
          message: "Server started",
          port: PORT
        })
      );
    }
  );
}

module.exports = {
  createServer
};
