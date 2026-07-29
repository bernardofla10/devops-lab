# Day 04 - Semgrep SAST Security Gate

## Create branch

```bash
git checkout main
git pull
git checkout -b week-04/day-04-semgrep-sast
```

## Validate application

```bash
cd app

npm install --package-lock-only
npm ci
npm run lint
npm test
```

## Semgrep version

```bash
docker run --rm \
  semgrep/semgrep:latest \
  semgrep --version
```

## Test custom rules

```bash
./scripts/test-rules.sh
```

## Generate reports

```bash
./scripts/semgrep-report.sh
```

## Run security gate

```bash
./scripts/semgrep-gate.sh
```

## Complete local pipeline

```bash
./scripts/ci-local.sh
```

## Inspect results

```bash
cat reports/semgrep.txt

jq '.results | length' \
  reports/semgrep.json

jq '.results[] | {
  check_id,
  path,
  severity: .extra.severity,
  message: .extra.message
}' reports/semgrep.json
```

## Push branch

```bash
git push -u origin week-04/day-04-semgrep-sast
```

## Create pull request

```bash
gh pr create \
  --base main \
  --head week-04/day-04-semgrep-sast \
  --title "Week 04 Day 04 - Semgrep SAST Security Gate" \
  --body "Adds custom Semgrep rules, SARIF reports and a blocking SAST gate."
```