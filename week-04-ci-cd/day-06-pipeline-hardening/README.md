# Day 06 - Branch Protection and Pipeline Hardening

This lab hardens the GitHub-based integration workflow.

## Pipeline

```text
Pull request
  |
  ├── Workflow security
  ├── Application quality
  └── Dependency review
          |
          v
Required - Hardened CI
          |
          v
Branch protection
          |
          v
Merge
```

## Main protections

- pull requests required for `main`
- required status check
- full commit SHA action pins
- least-privilege workflow permissions
- workflow concurrency
- dependency review
- CODEOWNERS
- pull request template
- Dependabot updates
- force-push protection
- branch-deletion protection

## Local validation

```bash
./scripts/ci-local.sh
```

## Pin GitHub Actions

```bash
./scripts/pin-actions.py
```

## Validate action pins

```bash
./scripts/check-action-pins.py
```

## Generate CODEOWNERS

```bash
./scripts/generate-codeowners.sh
```

## Audit remote repository settings

```bash
./scripts/audit-repository-settings.sh
```

## Required check

Configure branch protection to require:

```text
Required - Hardened CI
```

Do not require path-filtered workflows because they may not report a
status for every pull request.

## Solo repository note

A solo repository can require pull requests and status checks without
requiring another person's approval.

Do not require code-owner approval until another collaborator with
write access is available.