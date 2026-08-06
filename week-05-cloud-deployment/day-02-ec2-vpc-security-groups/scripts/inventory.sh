#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

INVENTORY_PATH="$REPORT_DIRECTORY/inventory"

mkdir -p "$INVENTORY_PATH"

echo "DevOps Lab AWS Inventory"
echo "========================"
echo ""
echo "Project tag: $PROJECT_TAG"
echo "Region:      $AWS_REGION"
echo ""

echo "1. VPCs"

aws_cli ec2 describe-vpcs \
  --filters \
    "Name=tag:Project,Values=$PROJECT_TAG" \
  > "$INVENTORY_PATH/vpcs.json"

echo "2. Subnets"

aws_cli ec2 describe-subnets \
  --filters \
    "Name=tag:Project,Values=$PROJECT_TAG" \
  > "$INVENTORY_PATH/subnets.json"

echo "3. Route tables"

aws_cli ec2 describe-route-tables \
  --filters \
    "Name=tag:Project,Values=$PROJECT_TAG" \
  > "$INVENTORY_PATH/route-tables.json"

echo "4. Internet Gateways"

aws_cli ec2 describe-internet-gateways \
  --filters \
    "Name=tag:Project,Values=$PROJECT_TAG" \
  > "$INVENTORY_PATH/internet-gateways.json"

echo "5. Security Groups"

aws_cli ec2 describe-security-groups \
  --filters \
    "Name=tag:Project,Values=$PROJECT_TAG" \
  > "$INVENTORY_PATH/security-groups.json"

echo "6. EC2 instances"

aws_cli ec2 describe-instances \
  --filters \
    "Name=tag:Project,Values=$PROJECT_TAG" \
    "Name=instance-state-name,Values=pending,running,stopping,stopped,shutting-down" \
  > "$INVENTORY_PATH/instances.json"

echo "7. EBS volumes"

aws_cli ec2 describe-volumes \
  --filters \
    "Name=tag:Project,Values=$PROJECT_TAG" \
  > "$INVENTORY_PATH/volumes.json"

echo "8. IAM role"

aws_cli iam get-role \
  --role-name "$INSTANCE_ROLE_NAME" \
  > "$INVENTORY_PATH/instance-role.json" \
  2> "$INVENTORY_PATH/instance-role.error" \
  || true

echo "9. Instance profile"

aws_cli iam get-instance-profile \
  --instance-profile-name "$INSTANCE_PROFILE_NAME" \
  > "$INVENTORY_PATH/instance-profile.json" \
  2> "$INVENTORY_PATH/instance-profile.error" \
  || true

echo ""
echo "Inventory summary"
echo "-----------------"

jq \
  '"VPCs: \(.Vpcs | length)"' \
  "$INVENTORY_PATH/vpcs.json"

jq \
  '"Subnets: \(.Subnets | length)"' \
  "$INVENTORY_PATH/subnets.json"

jq \
  '"Route tables: \(.RouteTables | length)"' \
  "$INVENTORY_PATH/route-tables.json"

jq \
  '"Internet Gateways: \(.InternetGateways | length)"' \
  "$INVENTORY_PATH/internet-gateways.json"

jq \
  '"Security Groups: \(.SecurityGroups | length)"' \
  "$INVENTORY_PATH/security-groups.json"

jq '
  [
    .Reservations[]?.Instances[]?
  ]
  | "Instances: \(length)"
' "$INVENTORY_PATH/instances.json"

jq \
  '"EBS volumes: \(.Volumes | length)"' \
  "$INVENTORY_PATH/volumes.json"

echo ""
echo "Inventory saved:"
echo "$INVENTORY_PATH"