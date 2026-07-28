# Day 01 - GitHub Actions Fundamentals

## Goal

Create the first continuous integration workflow for the DevOps Lab repository.

## Why CI matters

Without CI, developers must remember to run every validation manually.

CI automatically verifies the project after code changes.

Examples:

- syntax validation
- lint
- unit tests
- build
- security scans
- Docker image validation

## Workflow location

```text
.github/workflows/
```

## Workflow triggers

This lab uses:

- `push`
- `pull_request`
- `workflow_dispatch`

## Job

The workflow contains one job:

```text
quality
```

## Steps

The job performs:

1. repository checkout
2. Node.js setup
3. dependency installation
4. syntax validation
5. automated tests

## Local and remote consistency

The commands used by CI are also available locally:

```bash
npm ci
npm run lint
npm test
```

## Permissions

The workflow uses:

```yaml
permissions:
  contents: read
```

The workflow does not need write permissions.

## Failure behavior

A command that returns a non-zero exit code causes the step to fail.

Later steps are normally skipped after the failure.

## Important lessons

- CI should provide fast feedback.
- Tests must be deterministic.
- The lock file should be committed.
- CI should start from a clean dependency installation.
- Workflow permissions should be minimal.
- CI commands should be reproducible locally.
- A red pipeline should block code integration until corrected.
- Workflow logs are operational evidence, not just visual indicators.

## Debugging flow

```text
open failed workflow
  ↓
identify failed job
  ↓
identify failed step
  ↓
read command output
  ↓
reproduce command locally
  ↓
correct the cause
  ↓
push correction
```

## Next step

Add multiple jobs, dependencies between jobs, artifacts and Docker image validation.