const test = require("node:test");
const assert = require("node:assert/strict");
const path = require("node:path");
const { spawnSync } = require("node:child_process");

const cliPath = path.resolve(
  __dirname,
  "..",
  "bin",
  "cli.js"
);

function runCli(args) {
  return spawnSync(
    process.execPath,
    [cliPath, ...args],
    {
      encoding: "utf-8"
    }
  );
}

test("CLI adds two numbers", () => {
  const result = runCli(["add", "2", "3"]);

  assert.equal(result.status, 0);
  assert.equal(result.stdout.trim(), "5");
  assert.equal(result.stderr, "");
});

test("CLI multiplies two numbers", () => {
  const result = runCli(["multiply", "6", "7"]);

  assert.equal(result.status, 0);
  assert.equal(result.stdout.trim(), "42");
});

test("CLI rejects division by zero", () => {
  const result = runCli(["divide", "10", "0"]);

  assert.equal(result.status, 1);
  assert.match(
    result.stderr,
    /division by zero is not allowed/
  );
});

test("CLI rejects unknown operations", () => {
  const result = runCli(["power", "2", "3"]);

  assert.equal(result.status, 1);
  assert.match(
    result.stderr,
    /usage: calculator-cli/
  );
});