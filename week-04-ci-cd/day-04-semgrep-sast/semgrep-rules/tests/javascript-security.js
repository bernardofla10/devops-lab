const {
  exec,
  execFile
} = require("node:child_process");

function runUnsafeCommand(command) {
  // ruleid: javascript-child-process-exec
  exec(command, () => {});
}

function runUnsafeQualifiedCommand(command) {
  const childProcess =
    require("node:child_process");

  // ruleid: javascript-child-process-exec
  childProcess.exec(command, () => {});
}

function runSafeCommand(argument) {
  // ok: javascript-child-process-exec
  execFile(
    process.execPath,
    [
      "-p",
      argument
    ],
    () => {}
  );
}

function runUnsafeJavaScript(code) {
  // ruleid: javascript-eval-use
  eval(code);
}