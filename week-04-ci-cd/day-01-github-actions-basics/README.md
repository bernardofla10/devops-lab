# Day 01 - GitHub Actions Fundamentals

This lab introduces continuous integration with GitHub Actions.

## CI pipeline

```text
Push or pull request
  ↓
GitHub Actions workflow
  ↓
Ubuntu runner
  ↓
Checkout repository
  ↓
Set up Node.js
  ↓
Install dependencies
  ↓
Validate syntax
  ↓
Run tests
```

## Application

The example application contains basic calculator functions:

- addition
- subtraction
- multiplication
- division
- input validation
- division-by-zero validation

## Run locally

```bash
./scripts/ci-local.sh
```

Or:

```bash
cd app
npm ci
npm run lint
npm test
```

## Workflow

The workflow is stored at:

```text
.github/workflows/week-04-day-01-ci.yml
```

## Triggers

The workflow runs on:

- pushes to `main`
- pull requests targeting `main`
- manual execution

## Main workflow steps

```text
checkout
setup Node.js
npm ci
npm run lint
npm test
```

## Expected result

```text
6 tests
6 passed
0 failed
```

## Failure exercise

1. Change an expected test result.
2. Commit and push.
3. Observe the failed GitHub Actions check.
4. Correct the test.
5. Commit and push again.
6. Observe the successful check.