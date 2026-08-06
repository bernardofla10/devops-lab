#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

echo "Stop Observability Lab"
echo "======================"
echo ""

compose down \
  --remove-orphans

echo ""
echo "Lab stopped."