# Day 02 - Multiple Jobs, Matrix and Artifacts

This lab expands the GitHub Actions pipeline into multiple jobs.

## Pipeline

```text
metadata ───────────────┐
                        │
lint ───────────────────┼──> package ──> verify artifact
                        │
test Node 22 ───────────┤
test Node 24 ───────────┘

all jobs ──────────────────> workflow summary
```

## Concepts

- independent jobs
- parallel execution
- job dependencies with `needs`
- Node.js version matrix
- job outputs
- workflow artifacts
- artifact upload and download
- artifact smoke testing
- conditions with `always()`
- workflow summaries

## Local validation

```bash
./scripts/ci-local.sh
```

## Application

The application provides a calculator module and CLI.

Examples:

```bash
node app/bin/cli.js add 2 3
node app/bin/cli.js subtract 10 4
node app/bin/cli.js multiply 6 7
node app/bin/cli.js divide 20 4
```

## Generated files

Local CI creates:

```text
app/reports/test-report-local.txt
app/dist/calculator-package-local/
```

These files are ignored by Git.

## Workflow

```text
.github/workflows/week-04-day-02-multi-job.yml
```

## CI artifacts

The workflow produces:

```text
test-report-node-22
test-report-node-24
calculator-package-<short-sha>
```

## Failure behavior

If a matrix test fails:

- the test job fails
- its report is still uploaded
- the package job is skipped
- artifact verification is skipped
- the final summary still runs