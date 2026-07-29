# Day 02 - Multiple Jobs, Matrix and Artifacts

## Create branch

```bash
git checkout main
git pull
git checkout -b week-04/day-02-multiple-jobs-artifacts
```

## Generate lock file

```bash
cd app
npm install --package-lock-only
```

Alternative:

```bash
docker run --rm \
  -v "$PWD:/app" \
  -w /app \
  node:24-alpine \
  npm install --package-lock-only
```

## Run application

```bash
node bin/cli.js add 2 3
node bin/cli.js multiply 6 7
node bin/cli.js divide 20 4
```

## Validate

```bash
npm ci
npm run lint
npm test
```

## Generate test report

```bash
TEST_REPORT_FILE=reports/test-report-local.txt \
  npm run test:report
```

## Build package

```bash
PACKAGE_NAME=calculator-package-local \
  npm run build
```

## Smoke test package

```bash
node \
  dist/calculator-package-local/bin/cli.js \
  multiply \
  6 \
  7
```

## Run complete local CI

```bash
chmod +x scripts/ci-local.sh
./scripts/ci-local.sh
```

## Push branch

```bash
git push -u origin week-04/day-02-multiple-jobs-artifacts
```

## Create pull request

```bash
gh pr create \
  --base main \
  --head week-04/day-02-multiple-jobs-artifacts \
  --title "Week 04 Day 02 - Multiple Jobs and Artifacts" \
  --body "Adds parallel jobs, a Node.js matrix, job outputs, package artifacts and artifact verification."
```