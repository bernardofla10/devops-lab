#!/usr/bin/env bash

set -euo pipefail

echo "Fake app starting..."
echo "PID: $$"
echo "Running as user: $(whoami)"
echo "Current directory: $(pwd)"

COUNT=1

while true; do
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Fake app is healthy. Iteration: $COUNT"
  COUNT=$((COUNT + 1))
  sleep 10
done
