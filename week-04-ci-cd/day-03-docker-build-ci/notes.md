# Day 03 - Docker Build in CI

## Goal

Build, run and test a Docker image automatically with GitHub Actions.

## Pipeline stages

The workflow contains:

- application quality checks
- Dockerfile validation
- image metadata generation
- BuildKit image build
- Docker layer cache
- container healthcheck
- HTTP smoke tests
- image export
- artifact upload
- artifact download
- checksum verification
- second container test

## BuildKit

BuildKit performs the Docker build.

Buildx provides the command and GitHub Actions integration used to control the builder.

## Image loading

The image is built with:

```yaml
load: true
```

This makes it available to `docker run` on the GitHub runner.

## Image publishing

The workflow uses:

```yaml
push: false
```

The image is not published to Docker Hub or GHCR.

## Cache

The workflow exports build cache to GitHub Actions.

Future builds can reuse unchanged layers.

## Build metadata

The image receives:

- a stable CI test tag
- a commit SHA tag
- OCI labels
- build revision
- build version

## Smoke tests

The container test validates:

- container process
- Docker healthcheck
- root endpoint
- health endpoint
- version endpoint
- expected HTTP 500 endpoint

## Artifact

The image is saved as:

```text
devops-ci-api.tar.gz
```

A SHA-256 checksum is generated alongside it.

## Artifact verification

A second job:

1. downloads the image
2. verifies its checksum
3. loads it into Docker
4. runs another container
5. repeats the smoke tests

## Important lessons

- A successful Docker build does not guarantee a working container.
- Runtime tests should happen before publishing an image.
- Healthchecks should represent meaningful application health.
- A Docker image can be transferred between jobs as an artifact.
- Checksums help detect corrupted files.
- CI runners are temporary.
- External build cache reduces repeated work.
- Build and push are separate pipeline stages.
- A registry is not required to test an image.
- Diagnostic reports should be preserved after failures.

## Debugging flow

```text
application tests
  ↓
Dockerfile build check
  ↓
BuildKit logs
  ↓
docker image inspect
  ↓
docker run
  ↓
docker inspect health
  ↓
docker logs
  ↓
HTTP smoke tests
```

## Next step

Add Semgrep SAST as the first security gate.