const {
  execFile
} = require("node:child_process");

const allowedOperations = {
  "node-version": {
    executable: process.execPath,
    arguments: [
      "--version"
    ]
  },

  platform: {
    executable: process.execPath,
    arguments: [
      "-p",
      "process.platform"
    ]
  }
};

function runOperation(operation, callback) {
  const selectedOperation =
    allowedOperations[operation];

  if (!selectedOperation) {
    const error =
      new Error("operation is not allowed");

    error.code = "OPERATION_NOT_ALLOWED";

    callback(error);
    return;
  }

  execFile(
    selectedOperation.executable,
    selectedOperation.arguments,
    {
      timeout: 2000,
      shell: false
    },
    (error, stdout, stderr) => {
      if (error) {
        callback(error);
        return;
      }

      callback(
        null,
        {
          stdout: stdout.trim(),
          stderr: stderr.trim()
        }
      );
    }
  );
}

module.exports = {
  runOperation
};