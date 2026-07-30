# Day 06 - Pipeline Hardening Commands

## Create branch

```bash
git checkout main
git pull
git checkout -b week-04/day-06-pipeline-hardening
```

## Application checks

```bash
cd app

npm install --package-lock-only
npm ci --ignore-scripts
npm run lint
npm test
npm start
```

## Generate CODEOWNERS

```bash
./scripts/generate-codeowners.sh
```

## Pin every GitHub Action

```bash
./scripts/pin-actions.py
```

## Check action pins

```bash
./scripts/check-action-pins.py
```

## Complete local validation

```bash
./scripts/ci-local.sh
```

## Audit repository settings

```bash
./scripts/audit-repository-settings.sh
```

## Inspect action references

```bash
grep \
  --recursive \
  --line-number \
  --extended-regexp \
  'uses:' \
  .github/workflows
```

## Push branch

```bash
git push \
  -u origin \
  week-04/day-06-pipeline-hardening
```

## Create pull request

```bash
gh pr create \
  --base main \
  --head week-04/day-06-pipeline-hardening \
  --title "Week 04 Day 06 - Pipeline Hardening" \
  --body "Adds full-SHA action pinning, dependency review, CODEOWNERS, repository governance and a required CI gate."
```