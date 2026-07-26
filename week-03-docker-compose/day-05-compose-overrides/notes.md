# Day 05 - Docker Compose Overrides

## Goal

Understand how to maintain one common Compose model and apply environment-specific configuration.

## Compose files

### Base

```text
compose.yaml
```

Contains configuration shared by development and production.

### Development

```text
compose.override.yaml
```

Automatically loaded with the base file in the default Compose workflow.

### Production

```text
compose.production.yaml
```

Explicitly loaded after the base file.

## Development configuration

Development provides:

- bind-mounted source code
- automatic process restart after file changes
- direct API access
- direct PostgreSQL access
- simpler restart behavior

## Production configuration

Production provides:

- immutable application image
- no direct database exposure
- no direct API exposure
- restart policies
- resource limits
- read-only API filesystem
- internal backend network

## Merge behavior

Compose processes files in order.

Later files can:

- replace values
- extend mappings
- append or merge sequences
- add services
- add networks
- add volumes

## Environment files

The Compose `--env-file` option provides values for interpolation.

The `environment` section defines variables passed into the container.

These are related but different concepts.

## Important lessons

- Environment-specific differences should not require duplicating the entire Compose file.
- Development bind mounts should generally not be used in production.
- Production should run code packaged into the image.
- A changed source file requires an image rebuild in production.
- `docker compose config` shows the final merged configuration.
- File order matters.
- Relative paths are interpreted from the base Compose file.
- Development and production should use different project names during local comparisons.
- Real secret management requires more than committed environment files.
- Local production simulation is not the same as a complete production platform.

## Debugging flow

```bash
docker compose config
docker compose ps
docker compose logs --tail 50
docker compose exec api sh
docker inspect container-id
```

Then check:

- Which Compose files were loaded?
- In which order were they loaded?
- Which env file was used?
- Does the final configuration contain a development bind mount?
- Is the correct command configured?
- Are the correct ports published?
- Is the database exposed unexpectedly?
- Are production limits applied?
- Was the image rebuilt after changing code?
- Are development and production using different project names?

## Mistakes or doubts

- I started production without specifying `compose.production.yaml`.
- I accidentally loaded the development override in production.
- I expected a production container to read a changed host file.
- I forgot to rebuild the image.
- I exposed PostgreSQL in production.
- I assumed that lists were always replaced.
- I used paths relative to the override file instead of the base file.
- I committed a local environment file.

## Next step

Study Docker Compose healthcheck debugging, dependency failures and operational troubleshooting.