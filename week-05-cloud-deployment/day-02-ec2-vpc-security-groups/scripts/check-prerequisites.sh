#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

echo "EC2 Lab Prerequisites"
echo "====================="
echo ""

REQUIRED_COMMANDS=(
  aws
  curl
  jq
  git
  session-manager-plugin
)

MISSING_COMMANDS=()

for COMMAND_NAME in "${REQUIRED_COMMANDS[@]}"; do
  if command -v "$COMMAND_NAME" >/dev/null 2>&1; then
    printf '%-25s %s\n' \
      "$COMMAND_NAME" \
      "$(command -v "$COMMAND_NAME")"
  else
    printf '%-25s missing\n' \
      "$COMMAND_NAME"

    MISSING_COMMANDS+=("$COMMAND_NAME")
  fi
done

echo ""
echo "AWS configuration"
echo "-----------------"
echo "Profile: $AWS_PROFILE"
echo "Region:  $AWS_REGION"
echo ""

echo "Caller identity"
echo "---------------"

aws_cli sts get-caller-identity

echo ""
echo "HTTP source CIDR"
echo "----------------"
echo "$HTTP_ALLOWED_CIDR"

if [ "$HTTP_ALLOWED_CIDR" = "203.0.113.10/32" ]; then
  echo ""
  echo "Replace the example HTTP_ALLOWED_CIDR."
  exit 1
fi

if [[ "$HTTP_ALLOWED_CIDR" != */32 ]]; then
  echo ""
  echo "The lab expects a single IPv4 address using /32."
  exit 1
fi

CALLER_ARN="$(
  aws_cli \
    sts \
    get-caller-identity \
    --query Arn \
    --output text
)"

if [[ "$CALLER_ARN" == *":root" ]]; then
  echo ""
  echo "The AWS CLI must not use the root identity."
  exit 1
fi

if [ "${#MISSING_COMMANDS[@]}" -gt 0 ]; then
  echo ""
  echo "Missing commands:"
  printf '%s\n' "${MISSING_COMMANDS[@]}"
  exit 1
fi

echo ""
echo "Prerequisite check passed."