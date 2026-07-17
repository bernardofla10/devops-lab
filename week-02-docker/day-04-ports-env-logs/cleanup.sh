#!/usr/bin/env bash

set -euo pipefail

echo "Docker Day 04 Cleanup"
echo "====================="
echo ""

echo "Removing lab containers..."
docker rm -f env-app-day04 >/dev/null 2>&1 || true
docker rm -f env-app-day04-b >/dev/null 2>&1 || true
docker rm -f env-app-conflict >/dev/null 2>&1 || true

echo ""
echo "Remaining containers:"
docker ps -a

echo ""
echo "Images matching devops-env-app:"
docker images | grep devops-env-app || echo "No devops-env-app images found."

echo ""
echo "Cleanup finished."