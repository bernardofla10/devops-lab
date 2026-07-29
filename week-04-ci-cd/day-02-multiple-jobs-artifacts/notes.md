# Day 02 - Multiple Jobs, Matrix and Artifacts

## Goal

Create a GitHub Actions workflow with parallel jobs, dependencies, a Node.js matrix and workflow artifacts.

## Jobs

The workflow contains:

- metadata
- lint
- test
- package
- verify-artifact
- workflow-summary

## Parallel execution

The following jobs do not depend on each other:

- metadata
- lint
- test

They can execute in parallel.

## Matrix

The test job runs with:

- Node.js 22
- Node.js 24

This validates compatibility with multiple supported runtime versions.

## Dependencies

The package job uses:

```yaml
needs:
  - metadata
  - lint
  - test
```

It only executes after the quality jobs succeed.

## Outputs

The metadata job generates:

- short commit SHA
- package artifact name

The package job accesses those values through the `needs` context.

## Artifacts

The workflow creates:

- one test report for Node.js 22
- one test report for Node.js 24
- one distributable application package

## Artifact verification

A separate job:

1. downloads the package
2. lists its files
3. executes the CLI
4. checks the expected result
5. prints SHA-256 checksums

## Always conditions

Test reports use:

```yaml
if: ${{ always() }}
```

This preserves diagnostic output even when tests fail.

## Workflow summary

The final job writes a table to:

```text
GITHUB_STEP_SUMMARY
```

The summary shows the result of each job.

## Important lessons

- Independent jobs can reduce total pipeline time.
- `needs` creates an explicit dependency graph.
- A matrix avoids duplicating nearly identical jobs.
- `fail-fast: false` allows all matrix combinations to finish.
- Outputs transfer small values between jobs.
- Artifacts transfer files between jobs.
- Cache and artifacts have different purposes.
- Build output should be verified after downloading.
- Failure reports should remain available.
- A package should only be created after quality checks pass.

## Debugging flow

```text
identify failed job
  ↓
check matrix version
  ↓
read failed step output
  ↓
download test report
  ↓
reproduce with the same Node version
  ↓
correct locally
  ↓
push again
```

## Next step

Build and validate a Docker image inside GitHub Actions.