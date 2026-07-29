const {
  exec
} = require("node:child_process");

function runOperation(operation, callback) {
  exec(
    operation,
    {
      timeout: 2000
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