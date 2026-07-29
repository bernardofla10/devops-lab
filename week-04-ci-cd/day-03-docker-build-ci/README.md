# Day 03 - Docker Build in CI

This lab builds and tests a Docker image automatically with GitHub Actions.

## Pipeline

```text
Application quality
  ↓
Dockerfile build check
  ↓
Docker image build with BuildKit
  ↓
Load image into runner
  ↓
Start container
  ↓
Wait for Docker healthcheck
  ↓
Test HTTP endpoints
  ↓
Export image
  ↓
Upload image artifact
  ↓
Download in another job
  ↓
Verify checksum
  ↓
Load and test again
```

## Run locally

```bash
./scripts/ci-local.sh
```

## Build only

```bash
./scripts/build-local.sh
```

## Test container

```bash
./scripts/test-container.sh
```

## Export image

```bash
./scripts/export-image.sh
```

## Image

```text
devops-ci-api:local
```

## Application endpoints

| Endpoint | Expected result |
|---|---|
| `/` | HTTP 200 |
| `/health` | HTTP 200 and `status: ok` |
| `/version` | Image version and revision |
| `/error` | HTTP 500 |

## GitHub Actions workflow

```text
.github/workflows/week-04-day-03-docker-build.yml
```

## Workflow artifacts

```text
docker-smoke-test-report
docker-image-week04-day03
docker-artifact-verification-report
```

## Build versus push

This workflow builds and tests the image but does not publish it to a registry.

```text
build: yes
load: yes
test: yes
artifact: yes
push: no
```