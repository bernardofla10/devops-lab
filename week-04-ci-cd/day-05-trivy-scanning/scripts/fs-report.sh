#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

TRIVY_IMAGE="${TRIVY_IMAGE:-aquasec/trivy:0.72.0}"
TRIVY_CACHE="${TRIVY_CACHE:-$HOME/.cache/trivy}"
REPORT_DIRECTORY="$PROJECT_DIRECTORY/reports/filesystem"

mkdir -p "$TRIVY_CACHE"
mkdir -p "$REPORT_DIRECTORY"

run_trivy() {
  docker run --rm \
    -v "$PROJECT_DIRECTORY:/workspace:ro" \
    -v "$TRIVY_CACHE:/root/.cache/trivy" \
    "$TRIVY_IMAGE" \
    "$@"
}

echo "Trivy Filesystem Vulnerability Report"
echo "====================================="
echo ""

echo "1. Table report"

run_trivy \
  fs \
  --scanners vuln \
  --vuln-type library \
  --severity UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL \
  --format table \
  /workspace/app \
  | tee "$REPORT_DIRECTORY/trivy-fs.txt"

echo ""
echo "2. JSON report"

run_trivy \
  fs \
  --scanners vuln \
  --vuln-type library \
  --severity UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL \
  --format json \
  /workspace/app \
  > "$REPORT_DIRECTORY/trivy-fs.json"

echo "3. SARIF report"

run_trivy \
  fs \
  --scanners vuln \
  --vuln-type library \
  --severity HIGH,CRITICAL \
  --format sarif \
  /workspace/app \
  > "$REPORT_DIRECTORY/trivy-fs.sarif"

FINDING_COUNT="$(
  jq '
    [
      .Results[]?.Vulnerabilities[]?
    ]
    | length
  ' "$REPORT_DIRECTORY/trivy-fs.json"
)"

BLOCKING_COUNT="$(
  jq '
    [
      .Results[]?.Vulnerabilities[]?
      | select(
          (
            .Severity == "HIGH" or
            .Severity == "CRITICAL"
          )
          and
          (.FixedVersion != "")
        )
    ]
    | length
  ' "$REPORT_DIRECTORY/trivy-fs.json"
)"

echo ""
echo "Total findings: $FINDING_COUNT"
echo "Potentially blocking findings: $BLOCKING_COUNT"
echo ""

find "$REPORT_DIRECTORY" \
  -maxdepth 1 \
  -type f \
  -print \
  | sort