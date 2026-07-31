# Day 07 - Final DevSecOps Pipeline

## Goal

Combine the CI/CD and security controls studied during Week 04.

## Parallel jobs

The first phase runs:

- workflow security
- application quality
- dependency review
- Semgrep
- Trivy filesystem

## Build gate

The image is built only after every pre-build control passes.

## Image artifact

The image is exported to a compressed archive.

A SHA-256 checksum is generated.

A separate job downloads and verifies the artifact.

## Image security

The downloaded image is loaded into Docker and scanned by Trivy.

The image must pass its security policy before runtime testing.

## Runtime validation

The smoke test validates:

- container startup
- Docker healthcheck
- health endpoint
- readiness endpoint
- version metadata
- application endpoint
- expected error behavior

## Reports

The workflow preserves reports even when a gate fails.

This provides evidence for troubleshooting and security review.

## Required gate

One stable required check evaluates every upstream job:

```text
Required - Final DevSecOps Pipeline
```

## Least privilege

The workflow uses read-only repository permissions by default.

SARIF jobs receive `security-events: write` only where required.

## Fork safety

The workflow uses `pull_request`.

It does not use `pull_request_target`.

Repository secrets are not required by this pipeline.

## Important lessons

- Functional tests and security scans address different risks.
- Security checks should run before image publication.
- A successful build does not prove runtime correctness.
- Image scanning must happen after the image exists.
- Artifacts permit job separation without a registry.
- Checksums provide integrity validation.
- Reports and gates serve different purposes.
- Required checks turn CI results into merge policy.
- Every security exception should be reviewed and documented.
- Deployment should consume the same verified image artifact.

## Next step

Start Week 05: cloud deployment and runtime operations.