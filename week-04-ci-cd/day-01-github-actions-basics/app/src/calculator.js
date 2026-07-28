function validateNumber(value, argumentName) {
  if (typeof value !== "number" || Number.isNaN(value)) {
    throw new TypeError(`${argumentName} must be a valid number`);
  }
}

function add(firstNumber, secondNumber) {
  validateNumber(firstNumber, "firstNumber");
  validateNumber(secondNumber, "secondNumber");

  return firstNumber + secondNumber;
}

function subtract(firstNumber, secondNumber) {
  validateNumber(firstNumber, "firstNumber");
  validateNumber(secondNumber, "secondNumber");

  return firstNumber - secondNumber;
}

function multiply(firstNumber, secondNumber) {
  validateNumber(firstNumber, "firstNumber");
  validateNumber(secondNumber, "secondNumber");

  return firstNumber * secondNumber;
}

function divide(firstNumber, secondNumber) {
  validateNumber(firstNumber, "firstNumber");
  validateNumber(secondNumber, "secondNumber");

  if (secondNumber === 0) {
    throw new RangeError("division by zero is not allowed");
  }

  return firstNumber / secondNumber;
}

module.exports = {
  add,
  subtract,
  multiply,
  divide
};