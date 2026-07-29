# Trivy Security Policy

## Reporting policy

Reports include:

```text
UNKNOWN
LOW
MEDIUM
HIGH
CRITICAL
```

Reports include vulnerabilities with and without available fixes.

## Dependency gate

The filesystem gate blocks:

```text
severity:
  HIGH
  CRITICAL

vulnerability type:
  library

fix:
  available
```

Equivalent command:

```bash
trivy fs \
  --scanners vuln \
  --vuln-type library \
  --severity HIGH,CRITICAL \
  --ignore-unfixed \
  --exit-code 1 \
  app
```

## Image gate

The image gate blocks:

```text
severity:
  CRITICAL

vulnerability types:
  os
  library

fix:
  available
```

Equivalent command:

```bash
trivy image \
  --scanners vuln \
  --vuln-type os,library \
  --severity CRITICAL \
  --ignore-unfixed \
  --exit-code 1 \
  image-name
```

## Exceptions

Every exception must include:

- vulnerability ID
- affected package
- technical justification
- reachability analysis
- compensating control
- owner
- review ticket
- expiration date

## Prohibited responses

Do not:

- ignore every vulnerability
- disable the gate to merge a pull request
- use broad permanent exceptions
- ignore a finding without reviewing its path
- treat an unavailable fix as zero risk

## Review flow

```text
finding
  ↓
confirm package and version
  ↓
check fixed version
  ↓
analyze reachability
  ↓
upgrade, replace or mitigate
  ↓
document exception only if necessary
  ↓
rerun scan
```