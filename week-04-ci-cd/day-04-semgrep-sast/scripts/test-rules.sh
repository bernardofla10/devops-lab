#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

cd "$PROJECT_DIRECTORY"

SEMGREP_IMAGE="${SEMGREP_IMAGE:-semgrep/semgrep:latest}"

echo "Semgrep Custom Rule Tests"
echo "========================="
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
    --test \
    --config semgrep-rules/rules \
    semgrep-rules/tests

echo ""
echo "Custom rule tests passed."