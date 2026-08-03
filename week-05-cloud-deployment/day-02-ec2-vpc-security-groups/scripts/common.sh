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

STATE_DIRECTORY="$PROJECT_DIRECTORY/state"
STATE_FILE="$STATE_DIRECTORY/resources.env"
REPORT_DIRECTORY="$PROJECT_DIRECTORY/reports"

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

: "${AWS_PROFILE:?AWS_PROFILE must be set}"
: "${AWS_REGION:?AWS_REGION must be set}"
: "${AWS_OUTPUT:?AWS_OUTPUT must be set}"

: "${LAB_NAME:?LAB_NAME must be set}"
: "${PROJECT_TAG:?PROJECT_TAG must be set}"
: "${ENVIRONMENT:?ENVIRONMENT must be set}"
: "${OWNER_TAG:?OWNER_TAG must be set}"
: "${MANAGED_BY:?MANAGED_BY must be set}"

mkdir -p \
  "$STATE_DIRECTORY" \
  "$REPORT_DIRECTORY"

export AWS_DEFAULT_OUTPUT="$AWS_OUTPUT"
export AWS_PAGER=""

aws_cli() {
  aws \
    --profile "$AWS_PROFILE" \
    --region "$AWS_REGION" \
    --no-cli-pager \
    "$@"
}

load_state() {
  if [ -f "$STATE_FILE" ]; then
    set -a
    source "$STATE_FILE"
    set +a
  fi
}

save_state() {
  local KEY="$1"
  local VALUE="$2"
  local TEMP_FILE="${STATE_FILE}.tmp"

  touch "$STATE_FILE"

  grep \
    --invert-match \
    "^${KEY}=" \
    "$STATE_FILE" \
    > "$TEMP_FILE" || true

  printf '%s=%q\n' \
    "$KEY" \
    "$VALUE" \
    >> "$TEMP_FILE"

  mv "$TEMP_FILE" "$STATE_FILE"
}

require_state() {
  load_state

  local REQUIRED_KEY

  for REQUIRED_KEY in "$@"; do
    if [ -z "${!REQUIRED_KEY:-}" ]; then
      echo "Missing state value:"
      echo "$REQUIRED_KEY"
      echo ""
      echo "State file:"
      echo "$STATE_FILE"
      exit 1
    fi
  done
}

tag_ec2_resource() {
  local RESOURCE_ID="$1"
  local NAME_VALUE="$2"

  aws_cli ec2 create-tags \
    --resources "$RESOURCE_ID" \
    --tags \
      "Key=Name,Value=$NAME_VALUE" \
      "Key=Project,Value=$PROJECT_TAG" \
      "Key=Environment,Value=$ENVIRONMENT" \
      "Key=Owner,Value=$OWNER_TAG" \
      "Key=ManagedBy,Value=$MANAGED_BY"
}
