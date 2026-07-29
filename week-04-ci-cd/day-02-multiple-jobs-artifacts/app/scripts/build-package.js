const fs = require("node:fs");
const path = require("node:path");

const appDirectory = path.resolve(__dirname, "..");
const distDirectory = path.join(appDirectory, "dist");

const packageName =
  process.env.PACKAGE_NAME ||
  "calculator-package-local";

if (!/^[a-zA-Z0-9._-]+$/.test(packageName)) {
  throw new Error(
    "PACKAGE_NAME contains invalid characters"
  );
}

const outputDirectory = path.join(
  distDirectory,
  packageName
);

function copyFile(relativeSource, relativeDestination) {
  const source = path.join(
    appDirectory,
    relativeSource
  );

  const destination = path.join(
    outputDirectory,
    relativeDestination
  );

  fs.mkdirSync(
    path.dirname(destination),
    {
      recursive: true
    }
  );

  fs.copyFileSync(source, destination);
}

fs.rmSync(
  distDirectory,
  {
    recursive: true,
    force: true
  }
);

fs.mkdirSync(
  outputDirectory,
  {
    recursive: true
  }
);

copyFile("package.json", "package.json");
copyFile("package-lock.json", "package-lock.json");
copyFile(
  "src/calculator.js",
  "src/calculator.js"
);
copyFile(
  "bin/cli.js",
  "bin/cli.js"
);

fs.chmodSync(
  path.join(outputDirectory, "bin", "cli.js"),
  0o755
);

const manifest = {
  packageName,
  commitSha: process.env.GITHUB_SHA || "local",
  nodeVersion: process.version,
  files: [
    "package.json",
    "package-lock.json",
    "src/calculator.js",
    "bin/cli.js"
  ]
};

fs.writeFileSync(
  path.join(outputDirectory, "manifest.json"),
  `${JSON.stringify(manifest, null, 2)}\n`
);

console.log(
  `Package created at: ${outputDirectory}`
);

console.log(
  JSON.stringify(manifest, null, 2)
);