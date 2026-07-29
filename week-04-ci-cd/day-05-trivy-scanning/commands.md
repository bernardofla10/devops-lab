# Day 05 - Trivy Security Gates

## Create branch

```bash
git checkout main
git pull
git checkout -b week-04/day-05-trivy-scanning
```

## Application checks

```bash
cd app

npm install --package-lock-only
npm ci
npm run lint
npm test
```

## Trivy version

```bash
docker run --rm \
  aquasec/trivy:0.72.0 \
  --version
```

## Filesystem report

```bash
./scripts/fs-report.sh
```

## Filesystem gate

```bash
./scripts/fs-gate.sh
```

## Build image

```bash
./scripts/build-image.sh
```

## Image report

```bash
./scripts/image-report.sh
```

## Image gate

```bash
./scripts/image-gate.sh
```

## Smoke test

```bash
./scripts/smoke-test.sh
```

## Complete pipeline

```bash
chmod +x scripts/*.sh
./scripts/ci-local.sh
```

## Inspect JSON reports

```bash
jq '
  [
    .Results[]?.Vulnerabilities[]?
    | {
        VulnerabilityID,
        PkgName,
        InstalledVersion,
        FixedVersion,
        Severity
      }
  ]
' reports/filesystem/trivy-fs.json
```

## Upgrade vulnerable dependency

```bash
cd app

npm install \
  --save-exact \
  lodash@4.18.1
```

## Push branch

```bash
git push -u origin week-04/day-05-trivy-scanning
```

## Create pull request

```bash
gh pr create \
  --base main \
  --head week-04/day-05-trivy-scanning \
  --title "Week 04 Day 05 - Trivy Security Gates" \
  --body "Adds filesystem and image vulnerability scanning with Trivy security gates."
```