#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo "Docker Compose Events"
echo "====================="
echo ""
echo "Leave this terminal open."
echo "In another terminal, restart, stop or kill a service."
echo ""
echo "Exit with CTRL+C."
echo ""

docker compose events --json