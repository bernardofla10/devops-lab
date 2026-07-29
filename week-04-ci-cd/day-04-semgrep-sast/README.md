# Day 04 - Semgrep SAST Security Gate

This lab adds Static Application Security Testing to the CI pipeline with Semgrep Community Edition.

## Pipeline

```text
Application tests
  ↓
Semgrep custom-rule tests
  ↓
Semgrep report scan
  ↓
TXT, JSON and SARIF artifacts
  ↓
Blocking Semgrep gate
  ↓
Docker build
```

## Security scenario

The initial application uses:

```js
exec(operation, ...)
```

The custom Semgrep rule detects this pattern and blocks the Docker build.

The remediation replaces it with:

```js
execFile(executable, arguments, {
  shell: false
});
```

Only allowlisted operations are accepted.

## Run locally

```bash
./scripts/test-rules.sh
./scripts/semgrep-report.sh
./scripts/semgrep-gate.sh
./scripts/ci-local.sh
```

## Reports

```text
reports/semgrep.txt
reports/semgrep.json
reports/semgrep.sarif
```

## Custom rules

```text
semgrep-rules/rules/javascript-security.yml
```

## Rule tests

```text
semgrep-rules/tests/javascript-security.js
```

## GitHub Actions workflow

```text
.github/workflows/week-04-day-04-semgrep.yml
```

## Security-gate behavior

```text
finding detected
  ↓
Semgrep returns exit code 1
  ↓
Docker build is skipped

no findings
  ↓
Semgrep returns exit code 0
  ↓
Docker build runs
```