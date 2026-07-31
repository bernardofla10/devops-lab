# Day 07 - Final DevSecOps Pipeline Commands

## Create branch

```bash
git checkout main
git pull
git checkout -b week-04/day-07-final-devsecops
```

## Generate lock file

```bash
cd app

npm install --package-lock-only
npm ci --ignore-scripts
npm run lint
npm test
```

## Pin actions

```bash
./scripts/pin-actions.py
./scripts/check-action-pins.py
```

## Workflow security

```bash
./scripts/workflow-checks.sh
```

## Application quality

```bash
./scripts/app-checks.sh
```

## Semgrep

```bash
./scripts/semgrep-report.sh
./scripts/semgrep-gate.sh
```

## Trivy filesystem

```bash
./scripts/trivy-fs-report.sh
./scripts/trivy-fs-gate.sh
```

## Docker build

```bash
./scripts/build-image.sh
```

## Trivy image

```bash
./scripts/trivy-image-report.sh
./scripts/trivy-image-gate.sh
```

## Container smoke test

```bash
./scripts/smoke-test.sh
```

## Export image

```bash
./scripts/export-image.sh
```

## Complete local pipeline

```bash
chmod +x scripts/*.sh
chmod +x scripts/*.py

./scripts/ci-local.sh
```

## Push branch

```bash
git push \
  -u origin \
  week-04/day-07-final-devsecops
```

## Create pull request

```bash
gh pr create \
  --base main \
  --head week-04/day-07-final-devsecops \
  --title "Week 04 Day 07 - Final DevSecOps Pipeline" \
  --body "Adds the final CI/CD pipeline with workflow hardening, tests, dependency review, Semgrep, Trivy, Docker build, image artifacts and runtime smoke tests."
```