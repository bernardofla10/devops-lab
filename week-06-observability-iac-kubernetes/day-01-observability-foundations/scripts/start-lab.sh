#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

cd "$PROJECT_DIRECTORY"

BUILD_REVISION="$(
  git \
    -C "$REPOSITORY_ROOT" \
    rev-parse HEAD
)"

export BUILD_REVISION

echo "Start Observability Lab"
echo "======================="
echo ""
echo "Revision: $BUILD_REVISION"
echo "URL:      $BASE_URL"
echo ""

compose up \
  --detach \
  --build

echo ""
"$PROJECT_DIRECTORY/scripts/wait-for-health.sh"