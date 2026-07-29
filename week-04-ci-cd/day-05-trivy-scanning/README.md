# Day 05 - Trivy Dependency and Image Scanning

This lab adds Software Composition Analysis and container-image scanning to the CI pipeline.

## Pipeline

```text
Application tests
  ↓
Trivy filesystem reports
  ↓
Dependency security gate
  ↓
Docker build
  ↓
Trivy image reports
  ↓
Container image security gate
  ↓
Container smoke test
```

## Scans

### Filesystem scan

Analyzes:

- `package-lock.json`
- application libraries
- dependency versions

### Image scan

Analyzes:

- operating-system packages
- application libraries inside the image
- installed package versions

## Local pipeline

```bash
./scripts/ci-local.sh
```

## Filesystem report

```bash
./scripts/fs-report.sh
```

## Dependency gate

```bash
./scripts/fs-gate.sh
```

## Build image

```bash
./scripts/build-image.sh
```

## Image report

```bash
./scripts/image-report.sh
```

## Image gate

```bash
./scripts/image-gate.sh
```

## Reports

```text
reports/filesystem/
reports/image/
```

Formats:

- table
- JSON
- SARIF

## Security policy

Dependency gate:

```text
HIGH and CRITICAL
fixed vulnerabilities only
```

Image gate:

```text
CRITICAL
fixed vulnerabilities only
```

## Vulnerable dependency exercise

Initial version:

```text
lodash 4.17.23
```

Remediated version:

```text
lodash 4.18.1
```

## Workflow

```text
.github/workflows/week-04-day-05-trivy.yml
```