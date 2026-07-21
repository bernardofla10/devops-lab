const http = require("http");
const fs = require("fs");
const path = require("path");
const os = require("os");
const { URL } = require("url");

const APP_NAME = process.env.APP_NAME || "containerized-api";
const APP_ENV = process.env.APP_ENV || "development";
const PORT = Number(process.env.PORT || 3000);
const DATA_DIR = process.env.DATA_DIR || "/data";
const DATA_FILE = path.join(DATA_DIR, "items.json");

function ensureDataFile() {
  if (!fs.existsSync(DATA_DIR)) {
    fs.mkdirSync(DATA_DIR, { recursive: true });
  }

  if (!fs.existsSync(DATA_FILE)) {
    fs.writeFileSync(DATA_FILE, JSON.stringify([], null, 2));
  }
}

function readItems() {
  ensureDataFile();
  const raw = fs.readFileSync(DATA_FILE, "utf-8");
  return JSON.parse(raw);
}

function writeItems(items) {
  ensureDataFile();
  fs.writeFileSync(DATA_FILE, JSON.stringify(items, null, 2));
}

function sendJson(res, statusCode, payload) {
  res.writeHead(statusCode, { "Content-Type": "application/json" });
  res.end(JSON.stringify(payload, null, 2));
}

function log(level, message, extra = {}) {
  console.log(
    JSON.stringify({
      timestamp: new Date().toISOString(),
      level,
      message,
      app: APP_NAME,
      env: APP_ENV,
      hostname: os.hostname(),
      ...extra
    })
  );
}

function logRequest(req, statusCode) {
  log("info", "request handled", {
    method: req.method,
    url: req.url,
    statusCode
  });
}

ensureDataFile();

const server = http.createServer((req, res) => {
  const url = new URL(req.url, `http://${req.headers.host}`);

  if (url.pathname === "/health") {
    const payload = {
      status: "ok",
      app: APP_NAME,
      env: APP_ENV,
      hostname: os.hostname()
    };

    sendJson(res, 200, payload);
    logRequest(req, 200);
    return;
  }

  if (url.pathname === "/config") {
    const payload = {
      appName: APP_NAME,
      appEnv: APP_ENV,
      port: PORT,
      dataDir: DATA_DIR,
      dataFile: DATA_FILE,
      hostname: os.hostname()
    };

    sendJson(res, 200, payload);
    logRequest(req, 200);
    return;
  }

  if (url.pathname === "/items") {
    const items = readItems();

    sendJson(res, 200, {
      count: items.length,
      items,
      dataFile: DATA_FILE
    });

    logRequest(req, 200);
    return;
  }

  if (url.pathname === "/items/add") {
    const title = url.searchParams.get("title") || "untitled item";
    const items = readItems();

    const item = {
      id: items.length + 1,
      title,
      createdAt: new Date().toISOString(),
      hostname: os.hostname()
    };

    items.push(item);
    writeItems(items);

    sendJson(res, 201, {
      status: "created",
      item,
      totalItems: items.length
    });

    logRequest(req, 201);
    return;
  }

  if (url.pathname === "/error") {
    log("error", "simulated application error", {
      route: "/error"
    });

    sendJson(res, 500, {
      error: "simulated_error",
      message: "This endpoint intentionally returns an error for logging practice."
    });

    logRequest(req, 500);
    return;
  }

  sendJson(res, 200, {
    app: APP_NAME,
    env: APP_ENV,
    message: "Containerized API final Docker lab",
    endpoints: ["/", "/health", "/config", "/items", "/items/add?title=example", "/error"],
    persistencePath: DATA_FILE
  });

  logRequest(req, 200);
});

server.listen(PORT, "0.0.0.0", () => {
  log("info", "server started", {
    port: PORT,
    dataDir: DATA_DIR,
    dataFile: DATA_FILE
  });
});