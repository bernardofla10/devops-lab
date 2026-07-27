# Docker Compose Troubleshooting Checklist

## 1. Validate the effective configuration

```bash
docker compose config -q
docker compose config
docker compose config --services
docker compose config --networks
docker compose config --volumes
docker compose config --variables
```

Check:

- YAML syntax
- interpolation errors
- required variables
- service names
- ports
- networks
- volumes
- merged override files

## 2. Check all container states

```bash
docker compose ps
docker compose ps -a
docker compose ps --status exited
docker compose ps -a --format json
```

Look for:

- `running`
- `exited`
- `restarting`
- `healthy`
- `unhealthy`
- exit codes
- published ports

## 3. Read correlated logs

```bash
docker compose logs --tail 50
docker compose logs --tail 50 db
docker compose logs --tail 50 api
docker compose logs --tail 50 gateway
docker compose logs -f db api gateway
```

Start with the dependency and move outward:

```text
database
  ↓
API
  ↓
gateway
```

## 4. Inspect container state

```bash
docker inspect container-id
```

Useful fields:

```text
.State.Status
.State.ExitCode
.State.Error
.State.Health
.RestartCount
.Config.Env
.NetworkSettings
.Mounts
```

## 5. Test DNS

```bash
docker compose exec api \
  node -e "require('dns').lookup('db', console.log)"
```

Check:

- correct service name
- shared network
- container running
- application listening on the expected port

## 6. Test dependency connectivity

```bash
docker compose exec db \
  pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB"
```

Use a one-off API container when the main API cannot stay running:

```bash
docker compose run --rm --no-deps api sh
```

## 7. Check host ports

```bash
docker compose ps
docker ps --format 'table {{.Names}}\t{{.Ports}}'
sudo ss -tulpn
```

Look for:

- port already in use
- wrong host port
- wrong bind IP
- service without published port

## 8. Check healthcheck output

```bash
docker inspect \
  -f '{{json .State.Health}}' \
  container-id
```

Check:

- target port
- endpoint
- command availability
- timeout
- retries
- start period

## 9. Check credentials

Confirm that the same values are used by:

- PostgreSQL
- API
- local `.env`
- selected `--env-file`
- Compose overrides

Do not print real passwords in reports or commit them.

## 10. Check persistent state

```bash
docker volume ls
docker volume inspect volume-name
docker inspect -f '{{json .Mounts}}' container-id
```

Remember:

- changing initialization variables does not modify an initialized database
- initialization scripts do not rerun against a non-empty data directory
- `docker compose down` preserves named volumes
- `docker compose down -v` removes named volumes

## 11. Observe events

```bash
docker compose events --json
```

Useful for observing:

- create
- start
- stop
- die
- restart
- health status changes

## 12. Reproduce before fixing

Write down:

- command executed
- expected result
- actual result
- relevant log line
- hypothesis
- test performed
- final correction