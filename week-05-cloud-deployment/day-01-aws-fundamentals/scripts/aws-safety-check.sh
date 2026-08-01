#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

echo "AWS Account and Repository Safety Check"
echo "======================================="
echo ""

FAILURES=0
WARNINGS=0

echo "1. Checking caller identity"

CALLER_ARN="$(
  aws_cli \
    sts \
    get-caller-identity \
    --query Arn \
    --output text
)"

echo "Caller ARN: $CALLER_ARN"

if [[ "$CALLER_ARN" == *":root" ]]; then
  echo "FAIL: AWS CLI is using the root identity."
  FAILURES=$((FAILURES + 1))
else
  echo "PASS: AWS CLI is not using the root identity."
fi

echo ""
echo "2. Checking account MFA summary"

set +e

ACCOUNT_MFA_ENABLED="$(
  aws_cli \
    iam \
    get-account-summary \
    --query 'SummaryMap.AccountMFAEnabled' \
    --output text \
    2>/tmp/aws-day01-mfa-error.log
)"

MFA_RESULT=$?

set -e

if [ "$MFA_RESULT" -eq 0 ]; then
  if [ "$ACCOUNT_MFA_ENABLED" = "1" ]; then
    echo "PASS: Root-account MFA is reported as enabled."
  else
    echo "FAIL: Root-account MFA is not reported as enabled."
    FAILURES=$((FAILURES + 1))
  fi
else
  echo "WARN: Current role could not read the IAM account summary."
  WARNINGS=$((WARNINGS + 1))
fi

echo ""
echo "3. Checking repository for credential patterns"

SECRET_PATTERN='AKIA[0-9A-Z]{16}|ASIA[0-9A-Z]{16}|-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----'

set +e

git \
  -C "$REPOSITORY_ROOT" \
  grep \
  --line-number \
  --extended-regexp \
  "$SECRET_PATTERN" \
  -- .

SECRET_RESULT=$?

set -e

if [ "$SECRET_RESULT" -eq 0 ]; then
  echo "FAIL: A possible credential or private key was found."
  FAILURES=$((FAILURES + 1))
else
  echo "PASS: No matching credential pattern was found."
fi

echo ""
echo "4. Checking ignored local files"

if git \
  -C "$REPOSITORY_ROOT" \
  check-ignore \
  -q \
  "$PROJECT_DIRECTORY/config/lab.env"; then

  echo "PASS: config/lab.env is ignored."
else
  echo "FAIL: config/lab.env is not ignored."
  FAILURES=$((FAILURES + 1))
fi

if git \
  -C "$REPOSITORY_ROOT" \
  check-ignore \
  -q \
  "$PROJECT_DIRECTORY/reports/example.json"; then

  echo "PASS: generated reports are ignored."
else
  echo "FAIL: reports are not ignored."
  FAILURES=$((FAILURES + 1))
fi

echo ""
echo "Safety summary"
echo "--------------"
echo "Failures: $FAILURES"
echo "Warnings: $WARNINGS"

if [ "$FAILURES" -gt 0 ]; then
  echo ""
  echo "Safety check failed."
  exit 1
fi

echo ""
echo "Safety check passed."