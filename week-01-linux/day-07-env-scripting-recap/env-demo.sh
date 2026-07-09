#!/usr/bin/env bash

set -euo pipefail

ENV_FILE="${1:-.env}"

echo "Environment Variables Demo"
echo "=========================="
echo ""

if [ -f "$ENV_FILE" ]; then
  echo "Loading environment file: $ENV_FILE"
  set -a
  source "$ENV_FILE"
  set +a
else
  echo "Environment file not found: $ENV_FILE"
  echo "Using existing shell environment."
fi

echo ""
echo "Application configuration:"
echo "APP_NAME: ${APP_NAME:-not set}"
echo "APP_ENV: ${APP_ENV:-not set}"
echo "APP_PORT: ${APP_PORT:-not set}"
echo "HEALTH_URL: ${HEALTH_URL:-not set}"

echo ""
echo "Current shell information:"
echo "USER: ${USER:-not set}"
echo "HOME: ${HOME:-not set}"
echo "SHELL: ${SHELL:-not set}"

echo ""
echo "Environment demo finished successfully."