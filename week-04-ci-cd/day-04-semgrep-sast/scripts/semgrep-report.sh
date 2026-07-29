#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

cd "$PROJECT_DIRECTORY"

SEMGREP_IMAGE="${SEMGREP_IMAGE:-semgrep/semgrep:latest}"
REPORT_DIRECTORY="${REPORT_DIRECTORY:-reports}"

mkdir -p "$REPORT_DIRECTORY"

echo "Semgrep SAST Report"
echo "==================="
echo ""
echo "Image: $SEMGREP_IMAGE"
echo "Target: app/src"
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
    --text-output="$REPORT_DIRECTORY/semgrep.txt" \
    --json-output="$REPORT_DIRECTORY/semgrep.json" \
    --sarif-output="$REPORT_DIRECTORY/semgrep.sarif" \
    app/src

FINDING_COUNT="$(
  jq \
    '.results | length' \
    "$REPORT_DIRECTORY/semgrep.json"
)"

echo ""
echo "Findings: $FINDING_COUNT"
echo ""

echo "Generated reports:"

find "$REPORT_DIRECTORY" \
  -maxdepth 1 \
  -type f \
  -print \
  | sort