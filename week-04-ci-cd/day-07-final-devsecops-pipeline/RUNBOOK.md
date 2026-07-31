# Final DevSecOps Pipeline Runbook

## Local validation

```bash
./scripts/pin-actions.py
./scripts/ci-local.sh
```

## Workflow failure order

```text
workflow security
  ↓
application quality
  ↓
dependency review
  ↓
Semgrep
  ↓
Trivy filesystem
  ↓
Docker build
  ↓
Trivy image
  ↓
smoke test
```

## Workflow-security failure

Run:

```bash
./scripts/check-action-pins.py
./scripts/workflow-checks.sh
```

Check:

- unpinned action
- invalid YAML
- invalid expression
- `pull_request_target`
- invalid job dependency
- obsolete action input

## Application-quality failure

Run:

```bash
./scripts/app-checks.sh
```

Check:

- syntax error
- failed automated test
- incorrect runtime version
- lock-file inconsistency

## Semgrep failure

Run:

```bash
./scripts/semgrep-report.sh
./scripts/semgrep-gate.sh
```

Inspect:

```bash
cat reports/semgrep/semgrep.txt
jq '.results' reports/semgrep/semgrep.json
```

## Trivy filesystem failure

Run:

```bash
./scripts/trivy-fs-report.sh
./scripts/trivy-fs-gate.sh
```

Inspect:

```bash
jq '
  [
    .Results[]?.Vulnerabilities[]?
  ]
' reports/trivy-filesystem/trivy-fs.json
```

## Docker-build failure

Run:

```bash
./scripts/build-image.sh
```

Check:

- Dockerfile syntax
- build context
- missing files
- lock-file consistency
- BuildKit output
- base-image availability

## Trivy-image failure

Run:

```bash
./scripts/trivy-image-report.sh
./scripts/trivy-image-gate.sh
```

Check:

- vulnerable base image
- vulnerable OS package
- vulnerable application dependency
- fixed version
- package reachability
- documented exception policy

## Smoke-test failure

Run:

```bash
./scripts/smoke-test.sh
```

Check:

- process startup
- healthcheck output
- host port
- container logs
- environment variables
- endpoint status codes

## Image-artifact verification

```bash
cd artifacts

sha256sum \
  -c final-devsecops-api.tar.gz.sha256
```

Load:

```bash
gunzip \
  --stdout \
  artifacts/final-devsecops-api.tar.gz \
  | docker load
```

## Required-check failure

Open:

```text
Required - Final DevSecOps Pipeline
```

The job prints the result of every upstream job.

Do not bypass the check merely to merge.