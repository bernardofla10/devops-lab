#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

SEMGREP_IMAGE="${SEMGREP_IMAGE:-semgrep/semgrep:1.172.0}"

REPORT_DIRECTORY="$PROJECT_DIRECTORY/reports/semgrep"

mkdir -p "$REPORT_DIRECTORY"

echo "Semgrep SAST Reports"
echo "===================="
echo ""
echo "Image: $SEMGREP_IMAGE"
echo ""

docker run --rm \
  --user "$(id -u):$(id -g)" \
  -e HOME=/tmp \
  -v "$PROJECT_DIRECTORY:/src" \
  -w /src \
  "$SEMGREP_IMAGE" \
  semgrep scan \
    --metrics=off \
    --config semgrep-rules/rules \
    --text \
    --text-output=reports/semgrep/semgrep.txt \
    --json-output=reports/semgrep/semgrep.json \
    --sarif-output=reports/semgrep/semgrep.sarif \
    app/src

FINDING_COUNT="$(
  jq \
    '.results | length' \
    "$REPORT_DIRECTORY/semgrep.json"
)"

echo ""
echo "Findings: $FINDING_COUNT"
echo ""

find "$REPORT_DIRECTORY" \
  -maxdepth 1 \
  -type f \
  -print \
  | sort
