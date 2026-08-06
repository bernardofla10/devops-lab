#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

TRUST_POLICY_FILE="$PROJECT_DIRECTORY/iam/ec2-trust-policy.json"

echo "EC2 Systems Manager Instance Role"
echo "================================="
echo ""
echo "Role:             $INSTANCE_ROLE_NAME"
echo "Instance profile: $INSTANCE_PROFILE_NAME"
echo ""

echo "1. Creating or validating IAM role"

if aws_cli iam get-role \
  --role-name "$INSTANCE_ROLE_NAME" \
  >/dev/null 2>&1; then

  echo "IAM role already exists."
else
  aws_cli iam create-role \
    --role-name "$INSTANCE_ROLE_NAME" \
    --assume-role-policy-document \
      "file://$TRUST_POLICY_FILE" \
    --description \
      "EC2 role for the DevOps Lab Session Manager access"

  echo "IAM role created."
fi

echo ""
echo "2. Attaching AmazonSSMManagedInstanceCore"

aws_cli iam attach-role-policy \
  --role-name "$INSTANCE_ROLE_NAME" \
  --policy-arn \
    arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore

echo ""
echo "3. Creating or validating instance profile"

if aws_cli iam get-instance-profile \
  --instance-profile-name "$INSTANCE_PROFILE_NAME" \
  >/dev/null 2>&1; then

  echo "Instance profile already exists."
else
  aws_cli iam create-instance-profile \
    --instance-profile-name "$INSTANCE_PROFILE_NAME"

  echo "Instance profile created."
fi

echo ""
echo "4. Associating role with instance profile"

PROFILE_ROLE="$(
  aws_cli iam get-instance-profile \
    --instance-profile-name "$INSTANCE_PROFILE_NAME" \
    --query 'InstanceProfile.Roles[0].RoleName' \
    --output text
)"

if [ "$PROFILE_ROLE" = "$INSTANCE_ROLE_NAME" ]; then
  echo "Role is already associated."
elif [ "$PROFILE_ROLE" = "None" ]; then
  aws_cli iam add-role-to-instance-profile \
    --instance-profile-name "$INSTANCE_PROFILE_NAME" \
    --role-name "$INSTANCE_ROLE_NAME"

  echo "Role associated."
else
  echo "Unexpected role in the instance profile:"
  echo "$PROFILE_ROLE"
  exit 1
fi

save_state \
  INSTANCE_ROLE_NAME \
  "$INSTANCE_ROLE_NAME"

save_state \
  INSTANCE_PROFILE_NAME \
  "$INSTANCE_PROFILE_NAME"

echo ""
echo "5. Waiting for IAM propagation"

sleep 10

echo ""
echo "Instance role preparation completed."