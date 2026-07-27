# Day 06 - Docker Compose Troubleshooting

## Goal

Develop a structured method for diagnosing Docker Compose configuration and runtime failures.

## Troubleshooting sequence

```text
configuration
status
logs
inspection
internal tests
networks
volumes
correction
validation
```

## Configuration errors

Configuration errors occur before containers are created.

Examples:

- invalid YAML
- incorrect indentation
- required variable missing
- invalid interpolation
- invalid service structure

Primary command:

```bash
docker compose config -q
```

## Runtime errors

Runtime errors happen after Compose starts creating containers.

Examples:

- host port already in use
- application process exits
- dependency is unavailable
- healthcheck fails
- database authentication fails
- service DNS name is wrong

## Healthcheck failure

A container can be running but unhealthy.

This means:

```text
container process is alive
but
the configured health test is failing
```

Health details are available in:

```text
.State.Health
```

## DNS failure

Services communicate by Compose service name.

Correct:

```text
db:5432
```

Incorrect:

```text
missing-db:5432
localhost:5432
```

## Credential failure

Correct networking does not guarantee successful authentication.

The following can all be correct while login still fails:

- service DNS
- port
- database name
- container state
- network

Credentials must also match the initialized database.

## Stale volume

PostgreSQL initialization variables affect a new, empty data directory.

Changing the variable later does not change the password stored in an existing database volume.

## Exec versus run

```text
docker compose exec
  command inside an existing running container

docker compose run
  new one-off container using service configuration
```

`run` is useful when the primary service exits too quickly for `exec`.

## Events

Compose events help correlate actions such as:

- container creation
- startup
- shutdown
- death
- restart
- health changes

## Important lessons

- Validate configuration before starting containers.
- Always inspect stopped containers with `ps -a`.
- Read dependency logs before dependent-service logs.
- A running container can still be unhealthy.
- Restarting without understanding the cause can hide evidence.
- DNS, ports and credentials are separate troubleshooting dimensions.
- Named volumes can preserve outdated state.
- `down -v` is destructive.
- Use isolated project names for intentional failure labs.
- A reproducible failure is easier to fix than an intermittent guess.

## Debugging questions

- Is the effective Compose configuration valid?
- Which service failed first?
- Is the process running?
- What is the exit code?
- Is the container healthy?
- What does the healthcheck output say?
- Does the service name resolve?
- Is the target port correct?
- Are both containers in a shared network?
- Are credentials consistent?
- Is the volume carrying old state?
- Is the host port already occupied?

## Next step

Build a final Week 03 Compose project with tests, migration jobs, profiles and a complete operational runbook.