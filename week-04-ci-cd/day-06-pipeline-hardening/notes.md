# Day 06 - Branch Protection and Pipeline Hardening

## Goal

Protect the main branch and harden the GitHub Actions supply chain.

## Required status check

The repository requires:

```text
Required - Hardened CI
```

This job aggregates:

- workflow security
- application quality
- dependency review

## Action pinning

Actions are pinned to full commit SHAs.

Version tags remain as comments so Dependabot can update them.

## Workflow permissions

The workflow uses read-only repository permissions.

No job needs to modify repository contents or pull requests.

## Checkout credentials

Checkout credentials are not persisted because the workflow does not
push code.

## Dependency scripts

The application is installed using:

```bash
npm ci --ignore-scripts
```

This reduces execution of dependency lifecycle scripts.

## Dependency review

Dependency review analyzes packages introduced or changed by a pull
request.

It blocks HIGH and CRITICAL vulnerabilities.

## Concurrency

New commits cancel older runs for the same branch or pull request.

This saves runner time and avoids reviewing stale results.

## CODEOWNERS

CODEOWNERS documents responsibility for repository governance and
workflow files.

In a solo repository, Code Owner approval must not be mandatory.

## Fork safety

Pull-request workflows use the `pull_request` event.

They do not receive repository secrets from forks.

The repository does not use `pull_request_target` to execute pull
request code.

## Branch protection

The main branch requires pull requests and the hardened CI check.

Force pushes and branch deletion are disabled.

## Important lessons

- CI configuration is part of the software supply chain.
- Tags are easier to read but full SHAs are safer.
- Required checks need stable and unique names.
- A required workflow should not be skipped by path filters.
- Aggregator jobs should run with `always()`.
- Write permissions should be granted only when necessary.
- Fork pull requests must be treated as untrusted input.
- CODEOWNERS does not replace automated validation.
- A green workflow should be enforced by branch protection.
- Administrator bypasses should be exceptional and auditable.

## Next step

Build the final CI/CD and security pipeline for Week 04.