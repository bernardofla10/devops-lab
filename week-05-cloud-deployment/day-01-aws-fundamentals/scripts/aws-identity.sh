#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

REPORT_DIRECTORY="$PROJECT_DIRECTORY/reports/identity"

mkdir -p "$REPORT_DIRECTORY"

echo "AWS Identity Report"
echo "==================="
echo ""
echo "Profile: $AWS_PROFILE"
echo "Region:  $AWS_REGION"
echo ""

echo "1. Caller identity"

aws_cli sts get-caller-identity |
  tee "$REPORT_DIRECTORY/caller-identity.json"

echo ""
echo "2. AWS CLI profile configuration"

aws configure list \
  --profile "$AWS_PROFILE" |
  tee "$REPORT_DIRECTORY/aws-config.txt"

echo ""
echo "3. Current account ARN"

CALLER_ARN="$(
  aws_cli \
    sts \
    get-caller-identity \
    --query Arn \
    --output text
)"

echo "$CALLER_ARN"

echo ""
echo "Identity report generated:"
echo "$REPORT_DIRECTORY"