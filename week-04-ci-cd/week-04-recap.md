# Week 04 Recap - CI/CD and Security Gates

## Day 01 - GitHub Actions fundamentals

- workflows
- events
- jobs
- steps
- runners
- Node.js CI
- automated tests

## Day 02 - Multiple jobs and artifacts

- parallel jobs
- `needs`
- matrix
- job outputs
- artifact upload
- artifact download
- workflow summaries

## Day 03 - Docker build in CI

- BuildKit
- Buildx
- Docker metadata
- layer cache
- container healthcheck
- smoke tests
- exported image artifacts

## Day 04 - Semgrep SAST

- static application security testing
- custom rules
- rule tests
- JSON and SARIF
- blocking findings
- security-gated Docker build

## Day 05 - Trivy

- software composition analysis
- filesystem scanning
- dependency vulnerabilities
- container-image scanning
- fixed and unfixed vulnerabilities
- security policies

## Day 06 - Pipeline hardening

- branch protection
- required status checks
- action pinning
- least privilege
- dependency review
- CODEOWNERS
- Dependabot
- concurrency
- fork safety

## Day 07 - Final DevSecOps pipeline

- parallel quality and security gates
- gated Docker build
- image artifact
- checksum verification
- Trivy image gate
- runtime smoke test
- stable required check
- complete evidence retention

## Final pipeline

```text
source
  ↓
quality
  ↓
SAST and SCA
  ↓
Docker build
  ↓
image scanning
  ↓
runtime test
  ↓
required merge gate
```

## Most important lessons

- CI must be reproducible locally.
- Security must be part of the delivery workflow.
- Dependencies and images require different scans.
- Reports must remain available after failures.
- Workflow configuration is part of the supply chain.
- The artifact tested should be the artifact deployed.
- A green check matters only when branch protection enforces it.