#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

echo "AWS Lab Prerequisites"
echo "====================="
echo ""

REQUIRED_COMMANDS=(
  aws
  curl
  jq
  git
  ssh
)

MISSING_COMMANDS=()

for COMMAND_NAME in "${REQUIRED_COMMANDS[@]}"; do
  if command -v "$COMMAND_NAME" >/dev/null 2>&1; then
    printf '%-10s %s\n' \
      "$COMMAND_NAME" \
      "$(command -v "$COMMAND_NAME")"
  else
    printf '%-10s %s\n' \
      "$COMMAND_NAME" \
      "missing"

    MISSING_COMMANDS+=("$COMMAND_NAME")
  fi
done

echo ""
echo "Versions"
echo "--------"

aws --version
curl --version | head -n 1
jq --version
git --version
ssh -V 2>&1

echo ""
echo "Lab configuration"
echo "-----------------"
echo "Authentication: $AWS_AUTH_MODE"
echo "Profile:        $AWS_PROFILE"
echo "Region:         $AWS_REGION"
echo "Output:         $AWS_OUTPUT"

if [ "${#MISSING_COMMANDS[@]}" -gt 0 ]; then
  echo ""
  echo "Missing commands:"
  printf '%s\n' "${MISSING_COMMANDS[@]}"
  exit 1
fi

echo ""
echo "Prerequisite check passed."