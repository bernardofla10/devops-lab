const {
  test,
  before,
  after
} = require("node:test");

const assert =
  require("node:assert/strict");

const {
  createServer,
  validateMessage
} = require("../src/server");

let server;
let baseUrl;

before(async () => {
  server = createServer();

  await new Promise((resolve) => {
    server.listen(
      0,
      "127.0.0.1",
      resolve
    );
  });

  const address = server.address();

  baseUrl =
    `http://127.0.0.1:${address.port}`;
});

after(async () => {
  await new Promise((resolve, reject) => {
    server.close((error) => {
      if (error) {
        reject(error);
        return;
      }

      resolve();
    });
  });
});

test("GET / returns application information", async () => {
  const response =
    await fetch(baseUrl);

  const body =
    await response.json();

  assert.equal(response.status, 200);

  assert.equal(
    body.app,
    "final-devsecops-api"
  );

  assert.equal(
    body.message,
    "Final CI/CD and DevSecOps pipeline"
  );
});

test("GET /health returns status ok", async () => {
  const response =
    await fetch(`${baseUrl}/health`);

  const body =
    await response.json();

  assert.equal(response.status, 200);
  assert.equal(body.status, "ok");
});

test("GET /ready returns status ready", async () => {
  const response =
    await fetch(`${baseUrl}/ready`);

  const body =
    await response.json();

  assert.equal(response.status, 200);
  assert.equal(body.status, "ready");
});

test("GET /version returns build metadata", async () => {
  const response =
    await fetch(`${baseUrl}/version`);

  const body =
    await response.json();

  assert.equal(response.status, 200);
  assert.equal(typeof body.version, "string");
  assert.equal(typeof body.revision, "string");
});

test("GET /echo returns a validated message", async () => {
  const response =
    await fetch(
      `${baseUrl}/echo?message=devsecops`
    );

  const body =
    await response.json();

  assert.equal(response.status, 200);
  assert.equal(body.message, "devsecops");
  assert.equal(body.length, 9);
});

test("GET /echo rejects an empty message", async () => {
  const response =
    await fetch(`${baseUrl}/echo`);

  const body =
    await response.json();

  assert.equal(response.status, 400);
  assert.equal(body.error, "invalid_message");
});

test("GET /error returns HTTP 500", async () => {
  const response =
    await fetch(`${baseUrl}/error`);

  const body =
    await response.json();

  assert.equal(response.status, 500);
  assert.equal(body.error, "simulated_error");
});

test("validateMessage normalizes surrounding spaces", () => {
  assert.equal(
    validateMessage("  pipeline  "),
    "pipeline"
  );
});

test("validateMessage rejects oversized messages", () => {
  assert.throws(
    () => validateMessage("a".repeat(101)),
    {
      name: "RangeError",
      message:
        "message must not exceed 100 characters"
    }
  );
});