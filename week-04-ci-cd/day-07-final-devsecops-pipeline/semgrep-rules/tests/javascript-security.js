const {
  exec,
  execFile
} = require("node:child_process");

function unsafeCommand(command) {
  // ruleid: javascript-child-process-exec
  exec(command, () => {});
}

function unsafeQualifiedCommand(command) {
  const childProcess =
    require("node:child_process");

  // ruleid: javascript-child-process-exec
  childProcess.exec(command, () => {});
}

function safeCommand(argument) {
  // ok: javascript-child-process-exec
  execFile(
    process.execPath,
    [
      "-p",
      argument
    ],
    {
      shell: false
    },
    () => {}
  );
}

function unsafeEvaluation(code) {
  // ruleid: javascript-eval-use
  eval(code);
}