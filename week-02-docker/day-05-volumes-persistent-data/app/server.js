const http = require("http");
const fs = require("fs");
const path = require("path");
const { URL } = require("url");

const APP_NAME = process.env.APP_NAME || "docker-volumes-demo";
const APP_ENV = process.env.APP_ENV || "development";
const PORT = Number(process.env.PORT || 3000);
const DATA_DIR = process.env.DATA_DIR || "/data";
const DATA_FILE = path.join(DATA_DIR, "messages.json");

function ensureDataFile() {
  if (!fs.existsSync(DATA_DIR)) {
    fs.mkdirSync(DATA_DIR, { recursive: true });
  }

  if (!fs.existsSync(DATA_FILE)) {
    fs.writeFileSync(DATA_FILE, JSON.stringify([], null, 2));
  }
}

function readMessages() {
  ensureDataFile();
  const raw = fs.readFileSync(DATA_FILE, "utf-8");
  return JSON.parse(raw);
}

function writeMessages(messages) {
  ensureDataFile();
  fs.writeFileSync(DATA_FILE, JSON.stringify(messages, null, 2));
}

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
      dataFile: DATA_FILE
    })
  );
}

ensureDataFile();

const server = http.createServer((req, res) => {
  const url = new URL(req.url, `http://${req.headers.host}`);

  if (url.pathname === "/health") {
    sendJson(res, 200, {
      status: "ok",
      app: APP_NAME,
      env: APP_ENV
    });
    logRequest(req, 200);
    return;
  }

  if (url.pathname === "/data") {
    const messages = readMessages();
    sendJson(res, 200, {
      dataFile: DATA_FILE,
      count: messages.length,
      messages
    });
    logRequest(req, 200);
    return;
  }

  if (url.pathname === "/write") {
    const message = url.searchParams.get("message") || "default message";
    const messages = readMessages();

    const record = {
      id: messages.length + 1,
      message,
      createdAt: new Date().toISOString(),
      hostname: require("os").hostname()
    };

    messages.push(record);
    writeMessages(messages);

    sendJson(res, 201, {
      status: "written",
      record,
      dataFile: DATA_FILE
    });
    logRequest(req, 201);
    return;
  }

  sendJson(res, 200, {
    app: APP_NAME,
    env: APP_ENV,
    endpoints: ["/", "/health", "/write?message=hello", "/data"],
    dataDir: DATA_DIR,
    dataFile: DATA_FILE
  });
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
      dataDir: DATA_DIR,
      dataFile: DATA_FILE
    })
  );
});