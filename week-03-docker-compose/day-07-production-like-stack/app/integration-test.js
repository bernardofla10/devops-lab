const BASE_URL = process.env.BASE_URL || "http://gateway";

async function request(path, expectedStatus) {
  const response = await fetch(`${BASE_URL}${path}`);
  const body = await response.json();

  console.log(
    JSON.stringify({
      path,
      expectedStatus,
      actualStatus: response.status,
      body
    })
  );

  if (response.status !== expectedStatus) {
    throw new Error(
      `${path}: expected ${expectedStatus}, received ${response.status}`
    );
  }

  return body;
}

async function run() {
  console.log(`Running integration tests against ${BASE_URL}`);

  await request("/health", 200);
  await request("/ready", 200);

  const config = await request("/config", 200);

  if (config.passwordSource !== "compose-secret") {
    throw new Error("API is not using the Compose secret.");
  }

  await request("/migrations", 200);

  const uniqueTitle = `integration-test-${Date.now()}`;

  await request(
    `/items/add?title=${encodeURIComponent(uniqueTitle)}`,
    201
  );

  const itemsResponse = await request("/items", 200);

  const itemExists = itemsResponse.items.some(
    (item) => item.title === uniqueTitle
  );

  if (!itemExists) {
    throw new Error("Created item was not returned by /items.");
  }

  await request("/error", 500);

  console.log("All integration tests passed.");
}

run().catch((error) => {
  console.error(error);
  process.exit(1);
});