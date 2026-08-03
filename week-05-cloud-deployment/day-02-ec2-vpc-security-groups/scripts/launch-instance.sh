#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

require_state \
  VPC_ID \
  SUBNET_ID \
  SECURITY_GROUP_ID \
  INSTANCE_PROFILE_NAME

if [ -n "${INSTANCE_ID:-}" ]; then
  echo "An instance is already recorded:"
  echo "$INSTANCE_ID"
  exit 1
fi

echo "Amazon EC2 Instance Launch"
echo "=========================="
echo ""
echo "Instance type: $INSTANCE_TYPE"
echo "Subnet:        $SUBNET_ID"
echo "Security Group: $SECURITY_GROUP_ID"
echo ""

echo "1. Resolving the latest Amazon Linux 2023 AMI"

AMI_ID="$(
  aws_cli ssm get-parameter \
    --name "$AMI_SSM_PARAMETER" \
    --query 'Parameter.Value' \
    --output text
)"

echo "AMI: $AMI_ID"

save_state AMI_ID "$AMI_ID"

ROOT_DEVICE_NAME="$(
  aws_cli ec2 describe-images \
    --image-ids "$AMI_ID" \
    --query 'Images[0].RootDeviceName' \
    --output text
)"

echo "Root device: $ROOT_DEVICE_NAME"

save_state \
  ROOT_DEVICE_NAME \
  "$ROOT_DEVICE_NAME"

NETWORK_INTERFACE_SPEC="$(
  jq -nc \
    --arg subnet "$SUBNET_ID" \
    --arg security_group "$SECURITY_GROUP_ID" \
    '[
      {
        DeviceIndex: 0,
        SubnetId: $subnet,
        Groups: [$security_group],
        AssociatePublicIpAddress: true,
        DeleteOnTermination: true
      }
    ]'
)"

BLOCK_DEVICE_SPEC="$(
  jq -nc \
    --arg device "$ROOT_DEVICE_NAME" \
    --argjson volume_size "$ROOT_VOLUME_SIZE_GB" \
    '[
      {
        DeviceName: $device,
        Ebs: {
          DeleteOnTermination: true,
          Encrypted: true,
          VolumeSize: $volume_size,
          VolumeType: "gp3"
        }
      }
    ]'
)"

CREDIT_ARGUMENTS=()

if [[ "$INSTANCE_TYPE" =~ ^t(2|3|3a|4g)\. ]]; then
  CREDIT_ARGUMENTS=(
    --credit-specification
    CpuCredits=standard
  )
fi

echo ""
echo "2. Launching EC2 instance"

INSTANCE_ID="$(
  aws_cli ec2 run-instances \
    --image-id "$AMI_ID" \
    --instance-type "$INSTANCE_TYPE" \
    --count 1 \
    --iam-instance-profile \
      "Name=$INSTANCE_PROFILE_NAME" \
    --network-interfaces \
      "$NETWORK_INTERFACE_SPEC" \
    --block-device-mappings \
      "$BLOCK_DEVICE_SPEC" \
    --metadata-options \
      "HttpEndpoint=enabled,HttpTokens=required,HttpPutResponseHopLimit=1,InstanceMetadataTags=disabled" \
    --instance-initiated-shutdown-behavior stop \
    --user-data \
      "file://$PROJECT_DIRECTORY/user-data/bootstrap.sh" \
    "${CREDIT_ARGUMENTS[@]}" \
    --tag-specifications \
      "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME},{Key=Project,Value=$PROJECT_TAG},{Key=Environment,Value=$ENVIRONMENT},{Key=Owner,Value=$OWNER_TAG},{Key=ManagedBy,Value=$MANAGED_BY}]" \
      "ResourceType=volume,Tags=[{Key=Name,Value=${INSTANCE_NAME}-root},{Key=Project,Value=$PROJECT_TAG},{Key=Environment,Value=$ENVIRONMENT},{Key=Owner,Value=$OWNER_TAG},{Key=ManagedBy,Value=$MANAGED_BY}]" \
    --query 'Instances[0].InstanceId' \
    --output text
)"

save_state \
  INSTANCE_ID \
  "$INSTANCE_ID"

echo "Instance ID: $INSTANCE_ID"
echo ""

echo "3. Waiting for EC2 and Systems Manager"

"$PROJECT_DIRECTORY/scripts/wait-for-instance.sh"