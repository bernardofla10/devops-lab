# Day 07 - Environment Variables, Shell Scripting and Week 01 Recap

## Goal

Understand environment variables, improve shell scripting basics and consolidate Week 01 Linux operations.

## Why this matters for DevOps

Environment variables are used to configure applications and infrastructure without hardcoding values in code.

They are common in:

- Linux servers
- Docker
- Docker Compose
- CI/CD pipelines
- GitHub Actions
- cloud deployments
- backend applications
- systemd services

## Key concepts

An environment variable is a value available to a shell process and its child processes.

Examples:

```bash
APP_ENV=development
APP_PORT=8080
HEALTH_URL=http://localhost:8080/health
```

## `.env` and `.env.example`

`.env` contains real local values and must not be committed.

`.env.example` documents the variables needed by the project and can be committed.

## Export

```bash
export APP_ENV=development
```

`export` makes the variable available to child processes.

## Source

```bash
source .env
```

`source` loads variables into the current shell session.

## Safer Bash scripts

```bash
set -euo pipefail
```

Meaning:

- `set -e`: stop the script if a command fails
- `set -u`: fail when using undefined variables
- `pipefail`: fail if any command in a pipeline fails

## Commands practiced

- `export`
- `unset`
- `env`
- `printenv`
- `source`
- `chmod +x`
- `systemctl`
- `journalctl`
- `ss`
- `curl`
- `df`
- `free`
- `ps`
- `du`

## Important lessons

- Secrets must not be committed to GitHub.
- `.env.example` is useful documentation.
- Scripts should validate assumptions.
- Operational scripts help debug systems faster.
- A good DevOps workflow combines commands, logs, services and automation.

## Week 01 summary

This week covered:

- Linux terminal basics
- file permissions
- users and groups
- processes
- system resources
- systemd services
- logs with journalctl
- Nginx as a real service
- SSH and SCP
- environment variables
- shell scripting basics

## Mistakes or doubts

Write here what failed or confused you today.

Examples:

- I accidentally tried to commit `.env`.
- I forgot to run `chmod +x` on a script.
- I needed `sudo` for `ss -tulpn`.
- My Nginx health endpoint was not running.
- I confused shell variables with exported environment variables.

## Next step

Start Week 02: Docker fundamentals.