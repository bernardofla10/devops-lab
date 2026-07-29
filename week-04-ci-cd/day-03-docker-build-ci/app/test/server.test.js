const {
  test,
  before,
  after
} = require("node:test");

const assert = require("node:assert/strict");

const {
  createServer
} = require("../src/server");

let server;
let baseUrl;

before(async () => {
  server = createServer();

  await new Promise((resolve) => {
    server.listen(0, "127.0.0.1", resolve);
  });

  const address = server.address();

  baseUrl = `http://127.0.0.1:${address.port}`;
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
  const response = await fetch(baseUrl);
  const body = await response.json();

  assert.equal(response.status, 200);
  assert.equal(body.app, "docker-ci-api");
  assert.equal(body.message, "Docker build in CI lab");
});

test("GET /health returns a successful health status", async () => {
  const response = await fetch(`${baseUrl}/health`);
  const body = await response.json();

  assert.equal(response.status, 200);
  assert.equal(body.status, "ok");
});

test("GET /version returns image metadata", async () => {
  const response = await fetch(`${baseUrl}/version`);
  const body = await response.json();

  assert.equal(response.status, 200);
  assert.equal(body.app, "docker-ci-api");
  assert.equal(typeof body.version, "string");
  assert.equal(typeof body.revision, "string");
});

test("GET /error returns HTTP 500", async () => {
  const response = await fetch(`${baseUrl}/error`);
  const body = await response.json();

  assert.equal(response.status, 500);
  assert.equal(body.error, "simulated_error");
});