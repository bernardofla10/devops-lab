#!/usr/bin/env bash

set -euo pipefail

echo "Building Docker network lab images"
echo "=================================="
echo ""

echo "1. Building API image..."
docker build -f Dockerfile.api -t devops-network-api:day06 .
echo ""

echo "2. Building client image..."
docker build -f Dockerfile.client -t devops-network-client:day06 .
echo ""

echo "Images created:"
docker images | grep devops-network || true