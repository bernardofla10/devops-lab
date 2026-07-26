# Adminer, Profiles and Compose Networks Cheatsheet

## Validate

```bash
docker compose --profile tools config -q
docker compose config --profiles
docker compose --profile tools config --services
docker compose --profile tools config --networks
```

## Start core services

```bash
docker compose up -d --build
```

## Start with optional tools

```bash
docker compose --profile tools up -d --build
```

## Start only Adminer and dependencies

```bash
docker compose --profile tools up -d adminer
```

## Stop Adminer

```bash
docker compose --profile tools stop adminer
```

## Service status

```bash
docker compose --profile tools ps
```

## Public network

```yaml
networks:
  public-net:
    driver: bridge
```

## Private internal network

```yaml
networks:
  private-net:
    driver: bridge
    internal: true
```

## Service network membership

```yaml
services:
  db:
    networks:
      - private-net

  api:
    networks:
      - public-net
      - private-net
```

## Adminer service

```yaml
adminer:
  image: adminer:5-standalone
  profiles:
    - tools
  environment:
    ADMINER_DEFAULT_SERVER: db
  ports:
    - "127.0.0.1:8092:8080"
  networks:
    - public-net
    - private-net
```

## Inspect networks

```bash
docker network ls
docker network inspect devops-compose-day03_public-net
docker network inspect devops-compose-day03_private-net
```

## Check container networks

```bash
docker inspect \
  -f '{{range $name, $network := .NetworkSettings.Networks}}{{println $name $network.IPAddress}}{{end}}' \
  container-id
```

## Database internal address

```text
db:5432
```

## Adminer URL

```text
http://localhost:8092
```

## Important distinction

```text
ports:
  publishes a container port on the host

expose:
  documents an internal service port

networks:
  controls which services can communicate
```

## Shutdown

Preserve database:

```bash
docker compose --profile tools down
```

Remove database:

```bash
docker compose --profile tools down -v
```