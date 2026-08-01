#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

echo "AWS Authentication"
echo "=================="
echo ""
echo "Mode:    $AWS_AUTH_MODE"
echo "Profile: $AWS_PROFILE"
echo ""

case "$AWS_AUTH_MODE" in
  sso)
    aws sso login \
      --profile "$AWS_PROFILE"
    ;;

  existing-profile)
    echo "Using the existing AWS CLI profile."
    ;;

  *)
    echo "Unsupported AWS_AUTH_MODE:"
    echo "$AWS_AUTH_MODE"
    exit 1
    ;;
esac

echo ""
echo "Authenticated identity"
echo "----------------------"

aws_cli sts get-caller-identity