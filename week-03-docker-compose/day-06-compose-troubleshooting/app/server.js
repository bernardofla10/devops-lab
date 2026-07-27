const http = require("http");
const os = require("os");
const { URL } = require("url");
const { Pool } = require("pg");

const APP_NAME = process.env.APP_NAME || "scalable-compose-api";
const APP_ENV = process.env.APP_ENV || "development";
const PORT = Number(process.env.PORT || 3000);

const DB_HOST = process.env.DB_HOST || "db";
const DB_PORT = Number(process.env.DB_PORT || 5432);
const DB_NAME = process.env.DB_NAME || "devopsdb";
const DB_USER = process.env.DB_USER || "devops";
const DB_PASSWORD = process.env.DB_PASSWORD;

if (!DB_PASSWORD) {
  console.error(
    JSON.stringify({
      timestamp: new Date().toISOString(),
      level: "error",
      message: "DB_PASSWORD is required"
    })
  );

  process.exit(1);
}

const pool = new Pool({
  host: DB_HOST,
  port: DB_PORT,
  database: DB_NAME,
  user: DB_USER,
  password: DB_PASSWORD,
  max: 5,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 5000
});

function sleep(milliseconds) {
  return new Promise((resolve) => {
    setTimeout(resolve, milliseconds);
  });
}

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

async function connectWithRetry(maxAttempts = 20, delayMilliseconds = 2000) {
  for (let attempt = 1; attempt <= maxAttempts; attempt += 1) {
    try {
      await pool.query("SELECT 1");

      log("info", "database connection established", {
        dbHost: DB_HOST,
        dbPort: DB_PORT,
        dbName: DB_NAME,
        attempt
      });

      return;
    } catch (error) {
      log("error", "database connection attempt failed", {
        attempt,
        maxAttempts,
        error: error.message
      });

      if (attempt === maxAttempts) {
        throw error;
      }

      await sleep(delayMilliseconds);
    }
  }
}

async function ensureSchema() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS items (
      id SERIAL PRIMARY KEY,
      title TEXT NOT NULL,
      created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      created_by TEXT
    )
  `);

  await pool.query(`
    ALTER TABLE items
    ADD COLUMN IF NOT EXISTS created_by TEXT
  `);

  log("info", "database schema verified");
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

function runCpuWork(milliseconds) {
  const cappedMilliseconds = Math.min(
    Math.max(Number(milliseconds) || 500, 100),
    5000
  );

  const startedAt = Date.now();

  while (Date.now() - startedAt < cappedMilliseconds) {
    Math.sqrt(Math.random() * Number.MAX_SAFE_INTEGER);
  }

  return cappedMilliseconds;
}

const server = http.createServer(async (request, response) => {
  const url = new URL(request.url, `http://${request.headers.host}`);

  try {
    if (url.pathname === "/health") {
      await pool.query("SELECT 1");

      sendJson(response, 200, {
        status: "ok",
        database: "connected",
        hostname: os.hostname(),
        pid: process.pid
      });

      logRequest(request, 200);
      return;
    }

    if (url.pathname === "/instance") {
      sendJson(response, 200, {
        app: APP_NAME,
        env: APP_ENV,
        hostname: os.hostname(),
        pid: process.pid,
        uptimeSeconds: Math.round(process.uptime()),
        memoryUsage: process.memoryUsage()
      });

      logRequest(request, 200);
      return;
    }

    if (url.pathname === "/config") {
      sendJson(response, 200, {
        appName: APP_NAME,
        appEnv: APP_ENV,
        port: PORT,
        dbHost: DB_HOST,
        dbPort: DB_PORT,
        dbName: DB_NAME,
        dbUser: DB_USER,
        hostname: os.hostname()
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
      const hostname = os.hostname();

      const result = await pool.query(
        `
          INSERT INTO items (title, created_by)
          VALUES ($1, $2)
          RETURNING id, title, created_at, created_by
        `,
        [title, hostname]
      );

      sendJson(response, 201, {
        status: "created",
        servedBy: hostname,
        item: result.rows[0]
      });

      logRequest(request, 201);
      return;
    }

    if (url.pathname === "/work") {
      const requestedMilliseconds = url.searchParams.get("ms");
      const executedMilliseconds = runCpuWork(requestedMilliseconds);

      sendJson(response, 200, {
        status: "completed",
        hostname: os.hostname(),
        executedMilliseconds
      });

      logRequest(request, 200);
      return;
    }

    if (url.pathname === "/crash") {
      const hostname = os.hostname();

      log("error", "intentional process crash requested", {
        route: "/crash"
      });

      sendJson(response, 200, {
        status: "crashing",
        hostname,
        message: "This API instance will exit with code 1."
      });

      setTimeout(() => {
        process.exit(1);
      }, 150);

      return;
    }

    if (url.pathname === "/error") {
      log("error", "simulated application error", {
        route: "/error"
      });

      sendJson(response, 500, {
        error: "simulated_error",
        hostname: os.hostname()
      });

      logRequest(request, 500);
      return;
    }

    sendJson(response, 200, {
      app: APP_NAME,
      env: APP_ENV,
      message: "Docker Compose troubleshooting lab",
      servedBy: os.hostname(),
      endpoints: [
        "/",
        "/health",
        "/instance",
        "/config",
        "/items",
        "/items/add?title=example",
        "/work?ms=1000",
        "/crash",
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
      hostname: os.hostname(),
      message: error.message
    });
  }
});

async function start() {
  await connectWithRetry();
  await ensureSchema();

  server.listen(PORT, "0.0.0.0", () => {
    log("info", "API server started", {
      port: PORT,
      dbHost: DB_HOST,
      dbPort: DB_PORT
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
    log("error", "forced shutdown after timeout");
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