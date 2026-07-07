#!/usr/bin/env bash

set -euo pipefail

echo "Starting long-running task..."
echo "PID: $$"
echo "Press CTRL+C to stop manually."

COUNT=1

while true; do
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Task running... iteration $COUNT"
  COUNT=$((COUNT + 1))
  sleep 5
done
