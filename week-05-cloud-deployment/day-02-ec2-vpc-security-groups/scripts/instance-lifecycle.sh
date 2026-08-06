#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

require_state INSTANCE_ID

ACTION="${1:-status}"

case "$ACTION" in
  status)
    aws_cli ec2 describe-instances \
      --instance-ids "$INSTANCE_ID" \
      --query '
        Reservations[0].Instances[0].{
          InstanceId: InstanceId,
          State: State.Name,
          InstanceType: InstanceType,
          AvailabilityZone: Placement.AvailabilityZone,
          PrivateIp: PrivateIpAddress,
          PublicIp: PublicIpAddress,
          LaunchTime: LaunchTime
        }
      '
    ;;

  stop)
    echo "Stopping instance:"
    echo "$INSTANCE_ID"

    aws_cli ec2 stop-instances \
      --instance-ids "$INSTANCE_ID"

    aws_cli ec2 wait instance-stopped \
      --instance-ids "$INSTANCE_ID"

    echo ""
    echo "Instance stopped."
    echo "EC2 compute billing stopped."
    echo "EBS storage can still incur charges."
    ;;

  start)
    echo "Starting instance:"
    echo "$INSTANCE_ID"

    aws_cli ec2 start-instances \
      --instance-ids "$INSTANCE_ID"

    "$PROJECT_DIRECTORY/scripts/wait-for-instance.sh"

    echo ""
    echo "The automatically assigned public IPv4 may have changed."
    ;;

  *)
    echo "Usage:"
    echo "./scripts/instance-lifecycle.sh status"
    echo "./scripts/instance-lifecycle.sh stop"
    echo "./scripts/instance-lifecycle.sh start"
    exit 1
    ;;
esac