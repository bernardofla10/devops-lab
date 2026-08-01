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

CONFIG_FILE="${LAB_CONFIG_FILE:-$PROJECT_DIRECTORY/config/lab.env}"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Local configuration was not found:"
  echo "$CONFIG_FILE"
  echo ""
  echo "Create it with:"
  echo "cp config/lab.env.example config/lab.env"
  exit 1
fi

set -a
source "$CONFIG_FILE"
set +a

: "${AWS_AUTH_MODE:?AWS_AUTH_MODE must be set}"
: "${AWS_PROFILE:?AWS_PROFILE must be set}"
: "${AWS_REGION:?AWS_REGION must be set}"
: "${AWS_OUTPUT:?AWS_OUTPUT must be set}"

export AWS_PAGER=""

aws_cli() {
  aws \
    --profile "$AWS_PROFILE" \
    --region "$AWS_REGION" \
    --output "$AWS_OUTPUT" \
    "$@"
}
