#!/usr/bin/env bash

echo "Starting DevOps Day 01 script..."
echo "Current user: $(whoami)"
echo "Current directory: $(pwd)"
echo "Current date: $(date)"
echo "Operating system:"
cat /etc/os-release | head -n 5

echo ""
echo "Checking internet connectivity..."
curl -I https://example.com | head -n 1

echo ""
echo "Script finished successfully."
