# Week 03 Recap - Docker Compose

## Main goal

Learn how to define and operate multi-container applications with Docker Compose.

## Day 01 - Compose basics

- created the first `compose.yaml`
- defined a service
- configured ports
- configured environment variables
- created a named volume
- managed stack lifecycle

## Day 02 - API and PostgreSQL

- created two services
- used service discovery
- connected API to `db:5432`
- added PostgreSQL healthcheck
- persisted database data
- used `psql`

## Day 03 - Adminer and network isolation

- added a third service
- used Compose profiles
- created public and private networks
- removed direct database exposure
- tested network isolation

## Day 04 - Scaling and recovery

- scaled stateless API containers
- added an Nginx gateway
- tested restart policies
- simulated failures
- configured resource limits
- studied stateful versus stateless services

## Day 05 - Environment overrides

- created base, development and production files
- studied merge behavior
- used development bind mounts
- added production restrictions
- compared resolved configurations

## Day 06 - Troubleshooting

- created intentional failures
- diagnosed invalid YAML
- diagnosed missing variables
- diagnosed port conflicts
- diagnosed bad healthchecks
- diagnosed DNS failures
- diagnosed credential failures
- diagnosed stale volumes

## Day 07 - Production-like stack

- added migration job
- added Compose secrets
- added Compose configs
- added integration tests
- added Adminer profile
- added backup and restore
- created an operational runbook

## Most important commands

```bash
docker compose config
docker compose up
docker compose ps
docker compose logs
docker compose exec
docker compose run
docker compose build
docker compose restart
docker compose stop
docker compose start
docker compose down
docker compose down -v
docker compose events
```

## Main lessons

- Compose defines the runtime architecture of a multi-container application.
- Services communicate using service names.
- Healthchecks represent dependency readiness.
- One-off jobs are useful for migrations and tests.
- Stateless services are easier to scale.
- Stateful services require careful persistence and recovery.
- Development and production need different runtime configuration.
- Secrets, configs and profiles improve separation of responsibility.
- Persistent volumes must be backed up.
- Operational runbooks reduce improvisation during incidents.
- Troubleshooting should be based on evidence, not random restarts.

## Ready for Week 04

The next step is CI/CD with GitHub Actions:

- validate code
- run automated tests
- build Docker images
- validate Compose files
- scan dependencies
- run Semgrep
- run Trivy
- create security gates