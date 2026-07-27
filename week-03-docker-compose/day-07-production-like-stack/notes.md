# Day 07 - Production-like Docker Compose Stack

## Goal

Combine the main Docker Compose concepts from Week 03 into one operational project.

## Main services

- PostgreSQL
- migration job
- API
- Nginx gateway

## Optional services

- Adminer
- integration tests

## Migration job

The migration service:

1. waits for PostgreSQL to become healthy
2. applies the SQL migration
3. exits successfully
4. allows the API to start

The API depends on:

```yaml
condition: service_completed_successfully
```

## Secrets

The database password is mounted as:

```text
/run/secrets/db_password
```

It is not stored directly in the image.

## Configs

The Nginx configuration is provided through a Compose config.

This separates runtime configuration from the Nginx image.

## Health and readiness

```text
/health
  confirms that the HTTP process is alive

/ready
  confirms that the API can access PostgreSQL
```

## Profiles

Adminer uses:

```text
tools
```

Integration tests use:

```text
test
```

The main application does not depend on optional profiles.

## Backup and restore

The backup script uses `pg_dump`.

The restore script uses `psql`.

Backup files are stored outside containers and ignored by Git.

## Development configuration

Development includes:

- source-code bind mounts
- Node.js watch mode
- direct API access
- direct PostgreSQL access
- Adminer when requested

## Production configuration

Production includes:

- no source-code bind mount
- no direct API port
- no direct database port
- read-only API filesystem
- resource limits
- internal backend network
- restart policies

## Important lessons

- Schema changes should be handled by explicit migrations.
- Migration jobs must be idempotent.
- Application startup should depend on migration success.
- Credentials should not be embedded in images.
- Optional tools should not be required by the core stack.
- Health and readiness represent different conditions.
- Persistent volumes do not replace backup.
- Restore procedures must be tested before an incident.
- Configuration should be validated before deployment.
- Integration tests should run after meaningful changes.
- Operational documentation is part of a production-like system.

## Next step

Start Week 04: CI/CD with GitHub Actions and security gates.