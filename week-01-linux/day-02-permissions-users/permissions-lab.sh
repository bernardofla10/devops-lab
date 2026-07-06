#!/usr/bin/env bash

set -e

echo "Starting Linux permissions lab..."

LAB_DIR="permission-lab-output"

echo ""
echo "Creating lab directory..."
mkdir -p "$LAB_DIR"
cd "$LAB_DIR"

echo ""
echo "Creating files..."
touch app.log config.env deploy.sh

echo "APP_ENV=development" > config.env
echo "INFO application started" > app.log
echo 'echo "Deploy script running successfully."' > deploy.sh

echo ""
echo "Initial permissions:"
ls -la

echo ""
echo "Setting secure permissions..."
chmod 644 app.log
chmod 600 config.env
chmod 755 deploy.sh

echo ""
echo "Updated permissions:"
ls -la

echo ""
echo "Running deploy script:"
./deploy.sh

echo ""
echo "Current user information:"
whoami
id
groups

echo ""
echo "Linux permissions lab finished successfully."
