#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

REPORT_DIRECTORY="$PROJECT_DIRECTORY/reports/inventory"

mkdir -p "$REPORT_DIRECTORY"

capture_query() {
  local LABEL="$1"
  local OUTPUT_FILE="$2"

  shift 2

  echo ""
  echo "$LABEL"

  if aws_cli "$@" \
    > "$REPORT_DIRECTORY/$OUTPUT_FILE" \
    2> "$REPORT_DIRECTORY/$OUTPUT_FILE.error"; then

    rm -f "$REPORT_DIRECTORY/$OUTPUT_FILE.error"

    echo "Saved:"
    echo "$REPORT_DIRECTORY/$OUTPUT_FILE"
  else
    echo "WARN: Query failed."
    echo "See:"
    echo "$REPORT_DIRECTORY/$OUTPUT_FILE.error"
  fi
}

echo "AWS Read-only Inventory"
echo "======================="
echo ""
echo "Profile: $AWS_PROFILE"
echo "Region:  $AWS_REGION"

capture_query \
  "1. Caller identity" \
  "caller-identity.json" \
  sts get-caller-identity

capture_query \
  "2. AWS Regions" \
  "regions.json" \
  ec2 describe-regions \
  --all-regions

capture_query \
  "3. Availability Zones" \
  "availability-zones.json" \
  ec2 describe-availability-zones \
  --filters \
  Name=state,Values=available

capture_query \
  "4. VPCs" \
  "vpcs.json" \
  ec2 describe-vpcs

capture_query \
  "5. Subnets" \
  "subnets.json" \
  ec2 describe-subnets

capture_query \
  "6. Security Groups" \
  "security-groups.json" \
  ec2 describe-security-groups

capture_query \
  "7. EC2 Instances" \
  "ec2-instances.json" \
  ec2 describe-instances

capture_query \
  "8. ECR Repositories" \
  "ecr-repositories.json" \
  ecr describe-repositories

capture_query \
  "9. S3 Buckets" \
  "s3-buckets.json" \
  s3api list-buckets

capture_query \
  "10. CloudWatch Log Groups" \
  "cloudwatch-log-groups.json" \
  logs describe-log-groups \
  --limit 50

echo ""
echo "Inventory summary"
echo "-----------------"

if [ -f "$REPORT_DIRECTORY/availability-zones.json" ]; then
  jq \
    '"Availability Zones: \(.AvailabilityZones | length)"' \
    "$REPORT_DIRECTORY/availability-zones.json"
fi

if [ -f "$REPORT_DIRECTORY/vpcs.json" ]; then
  jq \
    '"VPCs: \(.Vpcs | length)"' \
    "$REPORT_DIRECTORY/vpcs.json"
fi

if [ -f "$REPORT_DIRECTORY/subnets.json" ]; then
  jq \
    '"Subnets: \(.Subnets | length)"' \
    "$REPORT_DIRECTORY/subnets.json"
fi

if [ -f "$REPORT_DIRECTORY/security-groups.json" ]; then
  jq \
    '"Security Groups: \(.SecurityGroups | length)"' \
    "$REPORT_DIRECTORY/security-groups.json"
fi

if [ -f "$REPORT_DIRECTORY/ec2-instances.json" ]; then
  jq \
    '[
      .Reservations[]?.Instances[]?
    ] | "EC2 Instances: \(length)"' \
    "$REPORT_DIRECTORY/ec2-instances.json"
fi

if [ -f "$REPORT_DIRECTORY/ecr-repositories.json" ]; then
  jq \
    '"ECR Repositories: \(.repositories | length)"' \
    "$REPORT_DIRECTORY/ecr-repositories.json"
fi

if [ -f "$REPORT_DIRECTORY/s3-buckets.json" ]; then
  jq \
    '"S3 Buckets: \(.Buckets | length)"' \
    "$REPORT_DIRECTORY/s3-buckets.json"
fi

echo ""
echo "Inventory completed."
echo "Reports are local and ignored by Git:"
echo "$REPORT_DIRECTORY"