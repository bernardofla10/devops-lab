# Day 01 - Observability Commands

## Create branch

```bash
git checkout main
git pull

git checkout -b \
  week-06/day-01-observability-foundations
```

## Application checks

```bash
cd app

npm install --package-lock-only
npm ci --ignore-scripts
npm run lint
npm test
```

## Start lab

```bash
./scripts/start-lab.sh
```

## Health

```bash
curl \
  http://127.0.0.1:18061/live

curl \
  http://127.0.0.1:18061/ready

curl \
  http://127.0.0.1:18061/health
```

## Metrics

```bash
curl \
  http://127.0.0.1:18061/metrics
```

## Logs

```bash
docker logs \
  --tail 50 \
  observability-api-day01

docker logs \
  --follow \
  observability-api-day01
```

## Full verification

```bash
./scripts/verify-observability.sh
```

## Incident simulation

```bash
./scripts/simulate-incident.sh
```

## Stop

```bash
./scripts/stop-lab.sh
```

## Push branch

```bash
git push \
  -u origin \
  week-06/day-01-observability-foundations
```

## Create pull request

```bash
gh pr create \
  --base main \
  --head week-06/day-01-observability-foundations \
  --title "Week 06 Day 01 - Observability Foundations" \
  --body "Adds structured logs, health endpoints, Prometheus metrics, Docker runtime evidence and an incident recovery exercise."
```