# Day 03 - Docker Build in CI

## Create branch

```bash
git checkout main
git pull
git checkout -b week-04/day-03-docker-build-ci
```

## Application validation

```bash
cd app

npm install --package-lock-only
npm ci
npm run lint
npm test
```

## Build image

```bash
./scripts/build-local.sh
```

Custom image reference:

```bash
./scripts/build-local.sh devops-ci-api:custom
```

## Test container

```bash
./scripts/test-container.sh
```

Custom image and port:

```bash
./scripts/test-container.sh \
  devops-ci-api:local \
  18080 \
  custom-test-container
```

## Export image

```bash
./scripts/export-image.sh
```

## Verify checksum

```bash
cd artifacts
sha256sum -c devops-ci-api.tar.gz.sha256
```

## Load image

```bash
gunzip \
  --stdout \
  artifacts/devops-ci-api.tar.gz \
  | docker load
```

## Complete local CI

```bash
chmod +x scripts/*.sh
./scripts/ci-local.sh
```

## Inspect image

```bash
docker image inspect devops-ci-api:local
docker history devops-ci-api:local
```

## Push branch

```bash
git push -u origin week-04/day-03-docker-build-ci
```

## Create pull request

```bash
gh pr create \
  --base main \
  --head week-04/day-03-docker-build-ci \
  --title "Week 04 Day 03 - Docker Build in CI" \
  --body "Adds Docker image builds, BuildKit cache, container smoke tests and image artifact verification."
```