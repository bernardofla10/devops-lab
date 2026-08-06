#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

require_state \
  INSTANCE_ID \
  SECURITY_GROUP_ID

REPORT_PATH="$REPORT_DIRECTORY/verification"

mkdir -p "$REPORT_PATH"

echo "EC2 Security and Runtime Verification"
echo "====================================="
echo ""

echo "1. Saving instance information"

aws_cli ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  > "$REPORT_PATH/instance.json"

echo "2. Saving Security Group information"

aws_cli ec2 describe-security-groups \
  --group-ids "$SECURITY_GROUP_ID" \
  > "$REPORT_PATH/security-group.json"

ROOT_DEVICE_NAME="$(
  jq -r \
    '.Reservations[0].Instances[0].RootDeviceName' \
    "$REPORT_PATH/instance.json"
)"

ROOT_VOLUME_ID="$(
  jq -r \
    --arg root "$ROOT_DEVICE_NAME" \
    '
      .Reservations[0].Instances[0]
      .BlockDeviceMappings[]
      | select(.DeviceName == $root)
      | .Ebs.VolumeId
    ' \
    "$REPORT_PATH/instance.json"
)"

aws_cli ec2 describe-volumes \
  --volume-ids "$ROOT_VOLUME_ID" \
  > "$REPORT_PATH/root-volume.json"

aws_cli ssm describe-instance-information \
  --filters \
    "Key=InstanceIds,Values=$INSTANCE_ID" \
  > "$REPORT_PATH/ssm.json"

echo ""
echo "3. Validating instance state"

INSTANCE_STATE="$(
  jq -r \
    '.Reservations[0].Instances[0].State.Name' \
    "$REPORT_PATH/instance.json"
)"

echo "State: $INSTANCE_STATE"

if [ "$INSTANCE_STATE" != "running" ]; then
  echo "Instance is not running."
  exit 1
fi

echo ""
echo "4. Validating IMDSv2"

HTTP_TOKENS="$(
  jq -r \
    '.Reservations[0].Instances[0].MetadataOptions.HttpTokens' \
    "$REPORT_PATH/instance.json"
)"

echo "HttpTokens: $HTTP_TOKENS"

if [ "$HTTP_TOKENS" != "required" ]; then
  echo "IMDSv2 is not required."
  exit 1
fi

echo ""
echo "5. Validating inbound SSH exposure"

SSH_RULE_COUNT="$(
  jq '
    [
      .SecurityGroups[0].IpPermissions[]?
      | select(
          .IpProtocol == "-1"
          or
          (
            .IpProtocol == "tcp"
            and
            .FromPort <= 22
            and
            .ToPort >= 22
          )
        )
    ]
    | length
  ' "$REPORT_PATH/security-group.json"
)"

echo "Rules allowing port 22: $SSH_RULE_COUNT"

if [ "$SSH_RULE_COUNT" -ne 0 ]; then
  echo "Inbound SSH access is present."
  exit 1
fi

echo ""
echo "6. Validating HTTP source"

HTTP_SOURCE_FOUND="$(
  jq \
    --arg cidr "$HTTP_ALLOWED_CIDR" \
    --argjson port "$HTTP_PORT" \
    '
      [
        .SecurityGroups[0].IpPermissions[]?
        | select(
            .IpProtocol == "tcp"
            and
            .FromPort == $port
            and
            .ToPort == $port
          )
        | .IpRanges[]?
        | select(.CidrIp == $cidr)
      ]
      | length
    ' \
    "$REPORT_PATH/security-group.json"
)"

echo "Matching HTTP rules: $HTTP_SOURCE_FOUND"

if [ "$HTTP_SOURCE_FOUND" -ne 1 ]; then
  echo "Expected HTTP rule was not found."
  exit 1
fi

echo ""
echo "7. Validating EBS encryption"

VOLUME_ENCRYPTED="$(
  jq -r \
    '.Volumes[0].Encrypted' \
    "$REPORT_PATH/root-volume.json"
)"

echo "Encrypted: $VOLUME_ENCRYPTED"

if [ "$VOLUME_ENCRYPTED" != "true" ]; then
  echo "Root EBS volume is not encrypted."
  exit 1
fi

DELETE_ON_TERMINATION="$(
  jq -r \
    --arg root "$ROOT_DEVICE_NAME" \
    '
      .Reservations[0].Instances[0]
      .BlockDeviceMappings[]
      | select(.DeviceName == $root)
      | .Ebs.DeleteOnTermination
    ' \
    "$REPORT_PATH/instance.json"
)"

echo "Delete on termination: $DELETE_ON_TERMINATION"

if [ "$DELETE_ON_TERMINATION" != "true" ]; then
  echo "Root volume will persist after termination."
  exit 1
fi

echo ""
echo "8. Validating Systems Manager"

SSM_STATUS="$(
  jq -r \
    '.InstanceInformationList[0].PingStatus // "Missing"' \
    "$REPORT_PATH/ssm.json"
)"

echo "SSM status: $SSM_STATUS"

if [ "$SSM_STATUS" != "Online" ]; then
  echo "Instance is not online in Systems Manager."
  exit 1
fi

echo ""
echo "9. Testing Nginx"

PUBLIC_IP="$(
  jq -r \
    '.Reservations[0].Instances[0].PublicIpAddress' \
    "$REPORT_PATH/instance.json"
)"

HTTP_STATUS="$(
  curl \
    --retry 10 \
    --retry-delay 3 \
    --retry-connrefused \
    --silent \
    --show-error \
    --output "$REPORT_PATH/index.html" \
    --write-out "%{http_code}" \
    "http://${PUBLIC_IP}/"
)"

echo "HTTP status: $HTTP_STATUS"

if [ "$HTTP_STATUS" != "200" ]; then
  echo "Nginx did not return HTTP 200."
  exit 1
fi

echo ""
echo "Verification passed."
echo ""
echo "Reports:"
echo "$REPORT_PATH"