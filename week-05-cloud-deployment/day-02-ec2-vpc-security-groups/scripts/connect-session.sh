#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

require_state INSTANCE_ID

if ! command -v session-manager-plugin \
  >/dev/null 2>&1; then

  echo "Session Manager plugin was not found."
  exit 1
fi

INSTANCE_STATE="$(
  aws_cli ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --query \
      'Reservations[0].Instances[0].State.Name' \
    --output text
)"

if [ "$INSTANCE_STATE" != "running" ]; then
  echo "Instance is not running:"
  echo "$INSTANCE_STATE"
  exit 1
fi

echo "Starting Session Manager session"
echo "================================"
echo ""
echo "Instance: $INSTANCE_ID"
echo ""
echo "Exit the remote shell with:"
echo "exit"
echo ""

aws_cli ssm start-session \
  --target "$INSTANCE_ID" \
  --reason \
    "Week 05 Day 02 EC2 administration lab"