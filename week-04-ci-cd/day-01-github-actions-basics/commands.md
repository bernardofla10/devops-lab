# Day 01 - GitHub Actions Fundamentals

## Create branch

```bash
git checkout main
git pull
git checkout -b week-04/day-01-github-actions
```

## Generate package lock

```bash
cd app
npm install --package-lock-only
```

Alternative with Docker:

```bash
docker run --rm \
  -v "$PWD:/app" \
  -w /app \
  node:20-alpine \
  npm install --package-lock-only
```

## Run locally

```bash
npm ci
npm run lint
npm test
npm run ci:local
```

## Local CI script

```bash
chmod +x scripts/ci-local.sh
./scripts/ci-local.sh
```

## Check repository status

```bash
git status
git diff
```

## Push branch

```bash
git push -u origin week-04/day-01-github-actions
```

## Create pull request with GitHub CLI

```bash
gh pr create \
  --base main \
  --head week-04/day-01-github-actions \
  --title "Week 04 Day 01 - GitHub Actions Fundamentals" \
  --body "Adds the first Node.js CI workflow with syntax validation and automated tests."
```

## Inspect workflow

```bash
sed -n '1,220p' \
  .github/workflows/week-04-day-01-ci.yml
```