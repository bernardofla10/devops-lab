#!/usr/bin/env node

const {
  add,
  subtract,
  multiply,
  divide
} = require("../src/calculator");

const operations = {
  add,
  subtract,
  multiply,
  divide
};

function parseNumber(rawValue, argumentName) {
  if (rawValue === undefined || rawValue.trim() === "") {
    throw new TypeError(`${argumentName} must be provided`);
  }

  const parsedValue = Number(rawValue);

  if (Number.isNaN(parsedValue)) {
    throw new TypeError(`${argumentName} must be a valid number`);
  }

  return parsedValue;
}

function main(args = process.argv.slice(2)) {
  const [operationName, firstRawValue, secondRawValue] = args;

  if (!operationName || !operations[operationName]) {
    throw new Error(
      "usage: calculator-cli <add|subtract|multiply|divide> <first> <second>"
    );
  }

  const firstNumber = parseNumber(firstRawValue, "firstNumber");
  const secondNumber = parseNumber(secondRawValue, "secondNumber");

  const result = operations[operationName](
    firstNumber,
    secondNumber
  );

  process.stdout.write(`${result}\n`);
}

try {
  main();
} catch (error) {
  console.error(error.message);
  process.exitCode = 1;
}