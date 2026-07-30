# GitHub Actions Security

## Least privilege

```yaml
permissions:
  contents: read
```

Grant write permissions only to the job that requires them.

## Full commit SHA pinning

Less secure:

```yaml
uses: actions/checkout@v7
```

Hardened:

```yaml
uses: actions/checkout@FULL_COMMIT_SHA # v7
```

## Checkout credentials

```yaml
with:
  persist-credentials: false
```

Use this when the workflow does not need to push commits or tags.

## Workflow concurrency

```yaml
concurrency:
  group: hardened-ci-${{ github.head_ref || github.ref }}
  cancel-in-progress: true
```

## Fork pull requests

Use:

```yaml
pull_request:
```

Avoid running untrusted code with:

```yaml
pull_request_target:
```

especially when the workflow has secrets or write permissions.

## Required check

Use one stable aggregator job:

```text
Required - Hardened CI
```

The aggregator must use:

```yaml
if: ${{ always() }}
```

## Avoid workflow-level path filters

A required workflow should run for every pull request.

A skipped workflow can leave its required status pending.

## Dependency installation

For applications that support it:

```bash
npm ci --ignore-scripts
```

Review projects that require dependency lifecycle scripts.

## Dependency review

```yaml
uses: actions/dependency-review-action@FULL_SHA
```

The action reviews newly introduced dependency risk.

## CODEOWNERS

Use CODEOWNERS for sensitive files such as:

```text
.github/workflows/
.github/dependabot.yml
deployment files
security policies
```

## Secrets

- do not print secrets
- do not send secrets to fork pull requests
- avoid long-lived cloud credentials
- use OIDC where supported
- mask sensitive derived values
- separate untrusted tests from privileged deployment jobs