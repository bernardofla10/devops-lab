#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo "Invalid YAML Lab"
echo "================"
echo ""

set +e

OUTPUT="$(
  docker compose \
    -f compose.yaml \
    -f broken/compose.invalid-yaml.yaml \
    config -q \
    2>&1
)"

RESULT=$?

set -e

echo "$OUTPUT"
echo ""

if [ "$RESULT" -ne 0 ]; then
  echo "Expected result: invalid YAML was detected."
else
  echo "Unexpected result: configuration was accepted."
  exit 1
fi