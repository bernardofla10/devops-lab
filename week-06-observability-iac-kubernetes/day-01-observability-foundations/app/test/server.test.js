const {
  after,
  before,
  test
} = require("node:test");

const assert =
  require("node:assert/strict");

const {
  createApplication,
  normalizeRoute
} = require("../src/server");

let application;
let baseUrl;

before(async () => {
  application =
    createApplication({
      startupDelayMs: 0,
      environment: "test",
      version: "test-version",
      revision: "test-revision"
    });

  await new Promise(
    (resolve) => {
      application.server.listen(
        0,
        "127.0.0.1",
        resolve
      );
    }
  );

  const address =
    application.server.address();

  baseUrl =
    `http://127.0.0.1:${address.port}`;
});

after(async () => {
  await new Promise(
    (resolve, reject) => {
      application.server.close(
        (error) => {
          if (error) {
            reject(error);
            return;
          }

          resolve();
        }
      );
    }
  );
});

test("GET / returns application information", async () => {
  const response =
    await fetch(baseUrl);

  const body =
    await response.json();

  assert.equal(
    response.status,
    200
  );

  assert.equal(
    body.app,
    "observability-foundations-api"
  );

  assert.equal(
    body.message,
    "Observability foundations lab"
  );

  assert.match(
    response.headers.get(
      "x-request-id"
    ),
    /^[A-Za-z0-9-]+$/
  );
});

test("GET /live returns alive", async () => {
  const response =
    await fetch(
      `${baseUrl}/live`
    );

  const body =
    await response.json();

  assert.equal(
    response.status,
    200
  );

  assert.equal(
    body.status,
    "alive"
  );
});

test("GET /ready returns ready", async () => {
  const response =
    await fetch(
      `${baseUrl}/ready`
    );

  const body =
    await response.json();

  assert.equal(
    response.status,
    200
  );

  assert.equal(
    body.status,
    "ready"
  );
});

test("GET /health returns aggregate health", async () => {
  const response =
    await fetch(
      `${baseUrl}/health`
    );

  const body =
    await response.json();

  assert.equal(
    response.status,
    200
  );

  assert.equal(
    body.status,
    "ok"
  );

  assert.equal(
    body.checks.live,
    true
  );

  assert.equal(
    body.checks.ready,
    true
  );
});

test("GET /work records a delayed request", async () => {
  const response =
    await fetch(
      `${baseUrl}/work?delayMs=10`
    );

  const body =
    await response.json();

  assert.equal(
    response.status,
    200
  );

  assert.equal(
    body.delayMs,
    10
  );
});

test("GET /error returns an intentional 500", async () => {
  const response =
    await fetch(
      `${baseUrl}/error`
    );

  const body =
    await response.json();

  assert.equal(
    response.status,
    500
  );

  assert.equal(
    body.error,
    "simulated_error"
  );
});

test("GET /metrics returns Prometheus text format", async () => {
  await fetch(
    `${baseUrl}/work?delayMs=20`
  );

  const response =
    await fetch(
      `${baseUrl}/metrics`
    );

  const body =
    await response.text();

  assert.equal(
    response.status,
    200
  );

  assert.match(
    response.headers.get(
      "content-type"
    ),
    /text\/plain/
  );

  assert.match(
    body,
    /observability_http_requests_total/
  );

  assert.match(
    body,
    /observability_http_request_duration_seconds_bucket/
  );

  assert.match(
    body,
    /route="\/work"/
  );

  assert.doesNotMatch(
    body,
    /delayMs/
  );
});

test("unknown paths use a bounded route label", async () => {
  const response =
    await fetch(
      `${baseUrl}/users/12345`
    );

  assert.equal(
    response.status,
    404
  );

  assert.equal(
    normalizeRoute(
      "/users/12345"
    ),
    "unknown"
  );
});

test("readiness can differ from liveness", async () => {
  const delayedApplication =
    createApplication({
      startupDelayMs:
        60000,

      environment:
        "test"
    });

  await new Promise(
    (resolve) => {
      delayedApplication.server.listen(
        0,
        "127.0.0.1",
        resolve
      );
    }
  );

  const address =
    delayedApplication.server.address();

  const delayedBaseUrl =
    `http://127.0.0.1:${address.port}`;

  const liveResponse =
    await fetch(
      `${delayedBaseUrl}/live`
    );

  const readyResponse =
    await fetch(
      `${delayedBaseUrl}/ready`
    );

  assert.equal(
    liveResponse.status,
    200
  );

  assert.equal(
    readyResponse.status,
    503
  );

  await new Promise(
    (resolve, reject) => {
      delayedApplication.server.close(
        (error) => {
          if (error) {
            reject(error);
            return;
          }

          resolve();
        }
      );
    }
  );
});