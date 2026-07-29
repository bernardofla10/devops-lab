#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

cd "$PROJECT_DIRECTORY"

SEMGREP_IMAGE="${SEMGREP_IMAGE:-semgrep/semgrep:latest}"

echo "Semgrep SAST Security Gate"
echo "=========================="
echo ""
echo "Blocking rules: HIGH and CRITICAL custom rules"
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
    --error \
    app/src

echo ""
echo "Security gate passed."