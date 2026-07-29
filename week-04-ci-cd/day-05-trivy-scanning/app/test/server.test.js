const {
  test,
  before,
  after
} = require("node:test");

const assert =
  require("node:assert/strict");

const {
  createServer
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
  const response = await fetch(baseUrl);
  const body = await response.json();

  assert.equal(response.status, 200);

  assert.equal(
    body.app,
    "trivy-security-lab"
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

test("GET /chunks groups values", async () => {
  const response =
    await fetch(`${baseUrl}/chunks`);

  const body =
    await response.json();

  assert.equal(response.status, 200);

  assert.deepEqual(
    body.chunks[0],
    [
      "linux",
      "docker"
    ]
  );
});

test("GET /version returns dependency version", async () => {
  const response =
    await fetch(`${baseUrl}/version`);

  const body =
    await response.json();

  assert.equal(response.status, 200);

  assert.equal(
    typeof body.lodashVersion,
    "string"
  );
});