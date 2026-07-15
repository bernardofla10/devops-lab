#!/usr/bin/env bash

set -euo pipefail

echo "Docker Lifecycle Cleanup"
echo "========================"
echo ""

echo "Removing lab containers..."
docker rm -f lifecycle-nginx >/dev/null 2>&1 || true
docker rm -f lifecycle-nginx-renamed >/dev/null 2>&1 || true
docker rm -f alpine-test >/dev/null 2>&1 || true
docker rm -f alpine-interactive >/dev/null 2>&1 || true

echo ""
echo "Remaining containers:"
docker ps -a

echo ""
echo "Images still available:"
docker images

echo ""
echo "Cleanup finished."