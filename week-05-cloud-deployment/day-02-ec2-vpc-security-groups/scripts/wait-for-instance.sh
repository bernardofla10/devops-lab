#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

require_state INSTANCE_ID

echo "Waiting for EC2 instance"
echo "========================"
echo ""
echo "Instance: $INSTANCE_ID"
echo ""

echo "1. Waiting for running state"

aws_cli ec2 wait instance-running \
  --instance-ids "$INSTANCE_ID"

echo "Instance is running."

echo ""
echo "2. Waiting for EC2 status checks"

aws_cli ec2 wait instance-status-ok \
  --instance-ids "$INSTANCE_ID"

echo "EC2 status checks passed."

echo ""
echo "3. Reading IP addresses"

PUBLIC_IP="$(
  aws_cli ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --query \
      'Reservations[0].Instances[0].PublicIpAddress' \
    --output text
)"

PRIVATE_IP="$(
  aws_cli ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --query \
      'Reservations[0].Instances[0].PrivateIpAddress' \
    --output text
)"

save_state PUBLIC_IP "$PUBLIC_IP"
save_state PRIVATE_IP "$PRIVATE_IP"

echo "Public IPv4:  $PUBLIC_IP"
echo "Private IPv4: $PRIVATE_IP"

echo ""
echo "4. Waiting for Systems Manager registration"

SSM_ONLINE=false

for ATTEMPT in $(seq 1 30); do
  PING_STATUS="$(
    aws_cli ssm describe-instance-information \
      --filters \
        "Key=InstanceIds,Values=$INSTANCE_ID" \
      --query \
        'InstanceInformationList[0].PingStatus' \
      --output text \
      2>/dev/null \
      || echo "Missing"
  )"

  echo \
    "Attempt $ATTEMPT/30: SSM status=$PING_STATUS"

  if [ "$PING_STATUS" = "Online" ]; then
    SSM_ONLINE=true
    break
  fi

  sleep 10
done

if [ "$SSM_ONLINE" != "true" ]; then
  echo ""
  echo "The instance did not become available in SSM."
  echo ""
  echo "Check:"
  echo "- instance profile"
  echo "- AmazonSSMManagedInstanceCore"
  echo "- outbound HTTPS"
  echo "- SSM Agent"
  echo "- cloud-init logs"
  exit 1
fi

echo ""
echo "Instance is ready for Session Manager."