const lodash = require("lodash");

function buildDependencyReport(values) {
  if (!Array.isArray(values)) {
    throw new TypeError("values must be an array");
  }

  return {
    dependency: "lodash",
    version: require("lodash/package.json").version,
    itemCount: values.length,
    groups: lodash.chunk(values, 2)
  };
}

if (require.main === module) {
  const report = buildDependencyReport([
    "branch-protection",
    "required-checks",
    "dependency-review",
    "action-pinning"
  ]);

  console.log(JSON.stringify(report, null, 2));
}

module.exports = {
  buildDependencyReport
};