#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

APP_DIR="$PROJECT_DIR/app"

echo "Week 04 Day 01 - Local CI"
echo "========================="
echo ""

cd "$APP_DIR"

echo "1. Environment"
echo "Node: $(node --version)"
echo "npm:  $(npm --version)"
echo ""

echo "2. Clean dependency installation"
npm ci
echo ""

echo "3. Syntax validation"
npm run lint
echo ""

echo "4. Automated tests"
npm test
echo ""

echo "Local CI completed successfully."