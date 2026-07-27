const http = require("http");
const fs = require("fs");
const os = require("os");
const { URL } = require("url");
const { Pool } = require("pg");

const APP_NAME = process.env.APP_NAME || "production-like-api";
const APP_ENV = process.env.APP_ENV || "development";
const PORT = Number(process.env.PORT || 3000);

function readSecret(filePath, fallbackValue) {
  if (fallbackValue) {
    return fallbackValue;
  }

  if (!filePath) {
    throw new Error("Secret file path was not provided.");
  }

  return fs.readFileSync(filePath, "utf-8").trim();
}

const DB_PASSWORD = readSecret(
  process.env.DB_PASSWORD_FILE,
  process.env.DB_PASSWORD
);

const pool = new Pool({
  host: process.env.DB_HOST || "db",
  port: Number(process.env.DB_PORT || 5432),
  database: process.env.DB_NAME || "devopsdb",
  user: process.env.DB_USER || "devops",
  password: DB_PASSWORD,
  max: 10,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 5000
});

function log(level, message, extra = {}) {
  const entry = {
    timestamp: new Date().toISOString(),
    level,
    message,
    app: APP_NAME,
    env: APP_ENV,
    hostname: os.hostname(),
    pid: process.pid,
    ...extra
  };

  const serialized = JSON.stringify(entry);

  if (level === "error") {
    console.error(serialized);
    return;
  }

  console.log(serialized);
}

function sendJson(response, statusCode, payload) {
  response.writeHead(statusCode, {
    "Content-Type": "application/json"
  });

  response.end(JSON.stringify(payload, null, 2));
}

function logRequest(request, statusCode) {
  log("info", "request handled", {
    method: request.method,
    url: request.url,
    statusCode
  });
}

const server = http.createServer(async (request, response) => {
  const url = new URL(request.url, `http://${request.headers.host}`);

  try {
    if (url.pathname === "/health") {
      sendJson(response, 200, {
        status: "ok",
        app: APP_NAME,
        env: APP_ENV,
        hostname: os.hostname()
      });

      logRequest(request, 200);
      return;
    }

    if (url.pathname === "/ready") {
      await pool.query("SELECT 1");

      sendJson(response, 200, {
        status: "ready",
        database: "connected",
        hostname: os.hostname()
      });

      logRequest(request, 200);
      return;
    }

    if (url.pathname === "/config") {
      sendJson(response, 200, {
        appName: APP_NAME,
        appEnv: APP_ENV,
        port: PORT,
        dbHost: process.env.DB_HOST,
        dbPort: process.env.DB_PORT,
        dbName: process.env.DB_NAME,
        dbUser: process.env.DB_USER,
        passwordSource: process.env.DB_PASSWORD_FILE
          ? "compose-secret"
          : "environment-variable",
        hostname: os.hostname()
      });

      logRequest(request, 200);
      return;
    }

    if (url.pathname === "/migrations") {
      const result = await pool.query(`
        SELECT version, applied_at
        FROM schema_migrations
        ORDER BY applied_at
      `);

      sendJson(response, 200, {
        count: result.rowCount,
        migrations: result.rows
      });

      logRequest(request, 200);
      return;
    }

    if (url.pathname === "/items") {
      const result = await pool.query(`
        SELECT id, title, created_at, created_by
        FROM items
        ORDER BY id
      `);

      sendJson(response, 200, {
        count: result.rowCount,
        servedBy: os.hostname(),
        items: result.rows
      });

      logRequest(request, 200);
      return;
    }

    if (url.pathname === "/items/add") {
      const title = url.searchParams.get("title") || "untitled item";

      const result = await pool.query(
        `
          INSERT INTO items (title, created_by)
          VALUES ($1, $2)
          RETURNING id, title, created_at, created_by
        `,
        [title, os.hostname()]
      );

      sendJson(response, 201, {
        status: "created",
        item: result.rows[0]
      });

      logRequest(request, 201);
      return;
    }

    if (url.pathname === "/error") {
      log("error", "simulated application error", {
        route: "/error"
      });

      sendJson(response, 500, {
        error: "simulated_error",
        message: "Intentional error for operational testing."
      });

      logRequest(request, 500);
      return;
    }

    sendJson(response, 200, {
      app: APP_NAME,
      env: APP_ENV,
      message: "Production-like Docker Compose stack",
      hostname: os.hostname(),
      endpoints: [
        "/",
        "/health",
        "/ready",
        "/config",
        "/migrations",
        "/items",
        "/items/add?title=example",
        "/error"
      ]
    });

    logRequest(request, 200);
  } catch (error) {
    log("error", "request processing failed", {
      method: request.method,
      url: request.url,
      error: error.message
    });

    sendJson(response, 500, {
      error: "internal_server_error",
      message: error.message
    });
  }
});

async function start() {
  await pool.query("SELECT 1");

  server.listen(PORT, "0.0.0.0", () => {
    log("info", "API server started", {
      port: PORT
    });
  });
}

async function shutdown(signal) {
  log("info", "shutdown signal received", {
    signal
  });

  server.close(async () => {
    await pool.end();

    log("info", "database pool closed");
    process.exit(0);
  });

  setTimeout(() => {
    log("error", "forced shutdown");
    process.exit(1);
  }, 10000).unref();
}

process.on("SIGTERM", () => {
  shutdown("SIGTERM");
});

process.on("SIGINT", () => {
  shutdown("SIGINT");
});

start().catch((error) => {
  log("error", "application startup failed", {
    error: error.message
  });

  process.exit(1);
});