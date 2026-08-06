#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

REPOSITORY_ROOT="$(
  cd "$PROJECT_DIRECTORY/../.." &&
  pwd
)"

COMPOSE_FILE="$PROJECT_DIRECTORY/compose.yml"
COMPOSE_PROJECT_NAME="week06-day01"

CONTAINER_NAME="observability-api-day01"
IMAGE_REFERENCE="observability-foundations-api:week06-day01"

BASE_URL="${BASE_URL:-http://127.0.0.1:18061}"

REPORT_DIRECTORY="$PROJECT_DIRECTORY/reports"

PROMETHEUS_IMAGE="${
  PROMETHEUS_IMAGE:-prom/prometheus:v3.13.2
}"

mkdir -p "$REPORT_DIRECTORY"

compose() {
  docker compose \
    --project-name "$COMPOSE_PROJECT_NAME" \
    --file "$COMPOSE_FILE" \
    "$@"
}