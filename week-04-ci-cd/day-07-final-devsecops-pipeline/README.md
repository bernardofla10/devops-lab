# Day 07 - Final CI/CD and DevSecOps Pipeline

This is the final project for Week 04.

## Pipeline

```text
Pull request
  |
  ├── Workflow security
  ├── Application quality
  ├── Dependency review
  ├── Semgrep SAST
  └── Trivy filesystem scan
          |
          v
     Docker build
          |
          v
    Image artifact
          |
          v
    Trivy image scan
          |
          v
    Container smoke test
          |
          v
Required DevSecOps gate
```

## Security gates

- GitHub Actions validation
- full-SHA action pinning
- application tests
- dependency review
- Semgrep SAST
- Trivy dependency scanning
- Trivy container-image scanning
- image-artifact checksum
- container healthcheck
- HTTP smoke tests

## Local pipeline

```bash
./scripts/pin-actions.py
./scripts/ci-local.sh
```

## Application

```text
GET /
GET /health
GET /ready
GET /version
GET /echo?message=hello
GET /error
```

## Local image

```text
final-devsecops-api:local
```

## Reports

```text
reports/tests/
reports/semgrep/
reports/trivy-filesystem/
reports/trivy-image/
reports/smoke-test/
```

## Image artifact

```text
artifacts/final-devsecops-api.tar.gz
artifacts/final-devsecops-api.tar.gz.sha256
```

## GitHub Actions workflow

```text
.github/workflows/week-04-day-07-final-devsecops.yml
```

## Required status check

Configure branch protection to require:

```text
Required - Final DevSecOps Pipeline
```

## Publishing

This project builds and tests the image but does not publish it to a
container registry.

```text
build: yes
security scan: yes
runtime test: yes
artifact: yes
registry push: no
deployment: no
```