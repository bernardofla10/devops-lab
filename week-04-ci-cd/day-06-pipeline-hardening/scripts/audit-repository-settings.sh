#!/usr/bin/env bash

set -euo pipefail

echo "GitHub Repository Security Audit"
echo "================================"
echo ""

if ! command -v gh >/dev/null 2>&1; then
  echo "GitHub CLI was not found."
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "GitHub CLI is not authenticated."
  exit 1
fi

REPOSITORY="$(
  gh repo view \
    --json nameWithOwner \
    --jq '.nameWithOwner'
)"

echo "Repository: $REPOSITORY"
echo ""

echo "1. Default workflow permissions"

if WORKFLOW_PERMISSIONS="$(
  gh api \
    "repos/$REPOSITORY/actions/permissions/workflow" \
    2>/dev/null
)"; then

  printf '%s\n' "$WORKFLOW_PERMISSIONS" |
    jq '{
      default_workflow_permissions,
      can_approve_pull_request_reviews
    }'
else
  echo "Could not read workflow permissions."
fi

echo ""
echo "2. GitHub Actions policy"

if ACTIONS_POLICY="$(
  gh api \
    "repos/$REPOSITORY/actions/permissions" \
    2>/dev/null
)"; then

  printf '%s\n' "$ACTIONS_POLICY" |
    jq '{
      enabled,
      allowed_actions,
      sha_pinning_required
    }'
else
  echo "Could not read Actions policy."
fi

echo ""
echo "3. Main branch protection"

if PROTECTION="$(
  gh api \
    "repos/$REPOSITORY/branches/main/protection" \
    2>/dev/null
)"; then

  printf '%s\n' "$PROTECTION" |
    jq '{
      required_status_checks: (
        .required_status_checks.contexts // []
      ),
      strict_status_checks: (
        .required_status_checks.strict // false
      ),
      approving_reviews: (
        .required_pull_request_reviews
        .required_approving_review_count // 0
      ),
      dismiss_stale_reviews: (
        .required_pull_request_reviews
        .dismiss_stale_reviews // false
      ),
      require_code_owner_reviews: (
        .required_pull_request_reviews
        .require_code_owner_reviews // false
      ),
      enforce_admins: (
        .enforce_admins.enabled // false
      ),
      conversation_resolution: (
        .required_conversation_resolution.enabled // false
      ),
      linear_history: (
        .required_linear_history.enabled // false
      ),
      allow_force_pushes: (
        .allow_force_pushes.enabled // false
      ),
      allow_deletions: (
        .allow_deletions.enabled // false
      )
    }'
else
  echo "Main branch protection was not found."
  echo "Configure it after the workflow runs."
fi