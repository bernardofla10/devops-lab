#!/usr/bin/env bash

set -euo pipefail

echo "Docker Networks Lab Cleanup"
echo "==========================="
echo ""

echo "1. Removing lab containers..."
docker rm -f api-day06 >/dev/null 2>&1 || true
docker rm -f client-day06 >/dev/null 2>&1 || true
docker rm -f client-day06-info >/dev/null 2>&1 || true
docker rm -f client-day06-default >/dev/null 2>&1 || true
docker rm -f client-localhost-test >/dev/null 2>&1 || true
docker rm -f client-isolated >/dev/null 2>&1 || true

echo ""
echo "2. Removing lab networks..."
docker network rm devops-net-day06 >/dev/null 2>&1 || true
docker network rm isolated-net-day06 >/dev/null 2>&1 || true

echo ""
echo "3. Remaining containers:"
docker ps -a

echo ""
echo "4. Remaining networks:"
docker network ls

echo ""
echo "Cleanup finished."