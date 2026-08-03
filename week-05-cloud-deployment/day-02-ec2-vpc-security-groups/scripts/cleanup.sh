#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

load_state

if [ "${1:-}" != "--confirm" ]; then
  echo "This command permanently deletes the lab infrastructure."
  echo ""
  echo "Run explicitly:"
  echo "./scripts/cleanup.sh --confirm"
  exit 1
fi

echo "AWS EC2 Lab Cleanup"
echo "==================="
echo ""

echo "1. Terminating EC2 instance"

if [ -n "${INSTANCE_ID:-}" ]; then
  set +e

  aws_cli ec2 terminate-instances \
    --instance-ids "$INSTANCE_ID"

  TERMINATE_RESULT=$?

  set -e

  if [ "$TERMINATE_RESULT" -eq 0 ]; then
    aws_cli ec2 wait instance-terminated \
      --instance-ids "$INSTANCE_ID"

    echo "Instance terminated."
  else
    echo "Instance was already absent or inaccessible."
  fi
else
  echo "No instance recorded."
fi

echo ""
echo "2. Deleting Security Group"

if [ -n "${SECURITY_GROUP_ID:-}" ]; then
  SECURITY_GROUP_DELETED=false

  for ATTEMPT in $(seq 1 12); do
    if aws_cli ec2 delete-security-group \
      --group-id "$SECURITY_GROUP_ID" \
      >/dev/null 2>&1; then

      SECURITY_GROUP_DELETED=true
      break
    fi

    echo \
      "Attempt $ATTEMPT/12: Security Group still in use."

    sleep 10
  done

  if [ "$SECURITY_GROUP_DELETED" != "true" ]; then
    echo "Could not delete Security Group."
    exit 1
  fi

  echo "Security Group deleted."
fi

echo ""
echo "3. Disassociating route table"

if [ -n "${ROUTE_TABLE_ASSOCIATION_ID:-}" ]; then
  aws_cli ec2 disassociate-route-table \
    --association-id "$ROUTE_TABLE_ASSOCIATION_ID" \
    >/dev/null 2>&1 || true
fi

echo ""
echo "4. Deleting route table"

if [ -n "${ROUTE_TABLE_ID:-}" ]; then
  aws_cli ec2 delete-route-table \
    --route-table-id "$ROUTE_TABLE_ID" \
    >/dev/null 2>&1 || true
fi

echo ""
echo "5. Detaching and deleting Internet Gateway"

if [ -n "${INTERNET_GATEWAY_ID:-}" ] &&
   [ -n "${VPC_ID:-}" ]; then

  aws_cli ec2 detach-internet-gateway \
    --internet-gateway-id "$INTERNET_GATEWAY_ID" \
    --vpc-id "$VPC_ID" \
    >/dev/null 2>&1 || true

  aws_cli ec2 delete-internet-gateway \
    --internet-gateway-id "$INTERNET_GATEWAY_ID" \
    >/dev/null 2>&1 || true
fi

echo ""
echo "6. Deleting subnet"

if [ -n "${SUBNET_ID:-}" ]; then
  aws_cli ec2 delete-subnet \
    --subnet-id "$SUBNET_ID" \
    >/dev/null 2>&1 || true
fi

echo ""
echo "7. Deleting VPC"

if [ -n "${VPC_ID:-}" ]; then
  aws_cli ec2 delete-vpc \
    --vpc-id "$VPC_ID" \
    >/dev/null 2>&1 || true
fi

echo ""
echo "8. Removing role from instance profile"

if [ -n "${INSTANCE_PROFILE_NAME:-}" ] &&
   [ -n "${INSTANCE_ROLE_NAME:-}" ]; then

  aws_cli iam remove-role-from-instance-profile \
    --instance-profile-name "$INSTANCE_PROFILE_NAME" \
    --role-name "$INSTANCE_ROLE_NAME" \
    >/dev/null 2>&1 || true
fi

echo ""
echo "9. Deleting instance profile"

if [ -n "${INSTANCE_PROFILE_NAME:-}" ]; then
  aws_cli iam delete-instance-profile \
    --instance-profile-name "$INSTANCE_PROFILE_NAME" \
    >/dev/null 2>&1 || true
fi

echo ""
echo "10. Detaching SSM policy"

if [ -n "${INSTANCE_ROLE_NAME:-}" ]; then
  aws_cli iam detach-role-policy \
    --role-name "$INSTANCE_ROLE_NAME" \
    --policy-arn \
      arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore \
    >/dev/null 2>&1 || true
fi

echo ""
echo "11. Deleting IAM role"

if [ -n "${INSTANCE_ROLE_NAME:-}" ]; then
  aws_cli iam delete-role \
    --role-name "$INSTANCE_ROLE_NAME" \
    >/dev/null 2>&1 || true
fi

echo ""
echo "12. Checking for remaining tagged resources"

mkdir -p "$REPORT_DIRECTORY/cleanup"

aws_cli ec2 describe-instances \
  --filters \
    "Name=tag:Project,Values=$PROJECT_TAG" \
    "Name=instance-state-name,Values=pending,running,stopping,stopped,shutting-down" \
  > "$REPORT_DIRECTORY/cleanup/remaining-instances.json"

aws_cli ec2 describe-volumes \
  --filters \
    "Name=tag:Project,Values=$PROJECT_TAG" \
  > "$REPORT_DIRECTORY/cleanup/remaining-volumes.json"

REMAINING_INSTANCES="$(
  jq '
    [
      .Reservations[]?.Instances[]?
    ]
    | length
  ' "$REPORT_DIRECTORY/cleanup/remaining-instances.json"
)"

REMAINING_VOLUMES="$(
  jq \
    '.Volumes | length' \
    "$REPORT_DIRECTORY/cleanup/remaining-volumes.json"
)"

echo "Remaining instances: $REMAINING_INSTANCES"
echo "Remaining volumes:   $REMAINING_VOLUMES"

if [ "$REMAINING_INSTANCES" -ne 0 ] ||
   [ "$REMAINING_VOLUMES" -ne 0 ]; then

  echo "Cleanup requires manual review."
  exit 1
fi

rm -f "$STATE_FILE"

echo ""
echo "Cleanup completed successfully."