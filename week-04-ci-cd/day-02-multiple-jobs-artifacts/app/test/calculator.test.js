const test = require("node:test");
const assert = require("node:assert/strict");

const {
  add,
  subtract,
  multiply,
  divide
} = require("../src/calculator");

test("add returns the sum of two numbers", () => {
  assert.equal(add(2, 3), 5);
});

test("subtract returns the difference between two numbers", () => {
  assert.equal(subtract(10, 4), 6);
});

test("multiply returns the product of two numbers", () => {
  assert.equal(multiply(6, 7), 42);
});

test("divide returns the quotient of two numbers", () => {
  assert.equal(divide(20, 4), 5);
});

test("divide rejects division by zero", () => {
  assert.throws(
    () => divide(10, 0),
    {
      name: "RangeError",
      message: "division by zero is not allowed"
    }
  );
});

test("operations reject non-numeric values", () => {
  assert.throws(
    () => add("2", 3),
    {
      name: "TypeError",
      message: "firstNumber must be a valid number"
    }
  );
});