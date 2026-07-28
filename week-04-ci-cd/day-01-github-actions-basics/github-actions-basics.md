# GitHub Actions Basics

## Workflow

A workflow is an automated process defined in a YAML file.

Location:

```text
.github/workflows/
```

## Event

An event starts a workflow.

Examples:

```yaml
on:
  push:
  pull_request:
  workflow_dispatch:
```

## Job

A job is a collection of steps executed on a runner.

```yaml
jobs:
  quality:
    runs-on: ubuntu-latest
```

## Runner

A runner is the machine that executes the job.

```yaml
runs-on: ubuntu-latest
```

## Step

A step is one operation in a job.

```yaml
steps:
  - name: Run tests
    run: npm test
```

## Action

An action is a reusable workflow component.

```yaml
uses: actions/checkout@v6
```

## Shell command

The `run` key executes shell commands.

```yaml
run: npm ci
```

## Working directory

```yaml
defaults:
  run:
    working-directory: path/to/application
```

## Permissions

```yaml
permissions:
  contents: read
```

Grant only the permissions required by the workflow.

## Exit codes

```text
exit code 0
  success

exit code different from 0
  failure
```

## CI rule

Every CI command should also work locally.

```text
local command
  =
CI command
```