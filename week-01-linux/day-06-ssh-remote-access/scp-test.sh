#!/usr/bin/env bash

set -euo pipefail

HOST="${1:-devops-local}"
REMOTE_DIR="${2:-ssh-lab-remote}"
LOCAL_FILE="/tmp/devops-scp-test.txt"

echo "SCP Test"
echo "========"
echo "Target host: $HOST"
echo "Remote directory: ~/$REMOTE_DIR"
echo ""

echo "Creating local test file..."
cat > "$LOCAL_FILE" <<EOF
Hello from DevOps Lab.
Created at: $(date)
Local user: $(whoami)
Local host: $(hostname)
EOF

echo "Creating remote directory..."
ssh "$HOST" "mkdir -p ~/$REMOTE_DIR"

echo "Copying file to remote host..."
scp "$LOCAL_FILE" "$HOST:~/$REMOTE_DIR/devops-scp-test.txt"

echo "Checking remote file..."
ssh "$HOST" "ls -la ~/$REMOTE_DIR && echo '' && cat ~/$REMOTE_DIR/devops-scp-test.txt"

echo ""
echo "SCP test finished successfully."