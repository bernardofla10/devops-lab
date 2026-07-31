#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

SEMGREP_IMAGE="${SEMGREP_IMAGE:-semgrep/semgrep:1.172.0}"

echo "Semgrep SAST Security Gate"
echo "=========================="
echo ""

echo "1. Testing custom rules"

docker run --rm \
  --user "$(id -u):$(id -g)" \
  -e HOME=/tmp \
  -v "$PROJECT_DIRECTORY:/src" \
  -w /src \
  "$SEMGREP_IMAGE" \
  semgrep scan \
    --metrics=off \
    --test \
    --config semgrep-rules/rules \
    semgrep-rules/tests

echo ""
echo "2. Scanning application source"

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
echo "Semgrep SAST security gate passed."
