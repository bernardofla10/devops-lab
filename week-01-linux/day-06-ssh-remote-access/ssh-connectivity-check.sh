#!/usr/bin/env bash

set -euo pipefail

HOST="${1:-devops-local}"

echo "SSH Connectivity Check"
echo "======================"
echo "Target host: $HOST"
echo ""

ssh \
  -o BatchMode=yes \
  -o ConnectTimeout=5 \
  "$HOST" '
    echo "SSH connection OK"
    echo "Remote user: $(whoami)"
    echo "Remote hostname: $(hostname)"
    echo "Remote uptime:"
    uptime
    echo ""
    echo "Disk usage:"
    df -h | head
  '

echo ""
echo "SSH connectivity check finished successfully."