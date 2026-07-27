#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo "Missing Required Variable Lab"
echo "============================="
echo ""

echo "1. Validating without REQUIRED_LAB_TOKEN..."

set +e

env -u REQUIRED_LAB_TOKEN \
  docker compose \
    -f compose.yaml \
    -f broken/compose.missing-variable.yaml \
    config -q

RESULT=$?

set -e

if [ "$RESULT" -ne 0 ]; then
  echo "Expected failure confirmed."
else
  echo "Unexpected success."
  exit 1
fi

echo ""
echo "2. Validating with REQUIRED_LAB_TOKEN..."

REQUIRED_LAB_TOKEN=local-lab-token \
  docker compose \
    -f compose.yaml \
    -f broken/compose.missing-variable.yaml \
    config -q

echo "Configuration passed after setting the variable."