# Final DevSecOps Pipeline Architecture

## Phase 1 - Parallel validation

```text
workflow-security
application-quality
dependency-review
semgrep
trivy-filesystem
```

## Phase 2 - Docker build

The Docker build requires:

```text
workflow-security = success
application-quality = success
dependency-review = success or skipped
semgrep = success
trivy-filesystem = success
```

## Phase 3 - Image security

```text
download image artifact
verify SHA-256 checksum
load Docker image
generate Trivy reports
apply image gate
run container
wait for healthcheck
run HTTP smoke tests
```

## Phase 4 - Required gate

```text
Required - Final DevSecOps Pipeline
```

The required gate evaluates every job explicitly.

## Security policies

### Semgrep

```text
block every finding from local HIGH and CRITICAL rules
```

### Trivy filesystem

```text
block:
  HIGH
  CRITICAL

scope:
  libraries

fix:
  available
```

### Trivy image

```text
block:
  CRITICAL

scope:
  operating-system packages
  application libraries

fix:
  available
```

## Evidence

Every pipeline run preserves:

- automated-test report
- Semgrep TXT, JSON and SARIF
- Trivy filesystem JSON and SARIF
- Trivy image JSON and SARIF
- container smoke-test report
- Docker image artifact
- Docker image checksum
- workflow summary