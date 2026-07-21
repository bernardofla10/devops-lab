# Containerized API Docker Cheatsheet

## Build image

```bash
docker build -t devops-api:week02-final .
```

## Run container

```bash
docker run -d \
  --name devops-api-day07 \
  --network devops-api-net-day07 \
  -p 8088:3000 \
  --env-file .env \
  -v devops-api-data-day07:/data \
  devops-api:week02-final
```

## Test API

```bash
curl http://localhost:8088
curl http://localhost:8088/health
curl http://localhost:8088/config
curl http://localhost:8088/items
curl "http://localhost:8088/items/add?title=example"
```

## Logs

```bash
docker logs devops-api-day07
docker logs --tail 20 devops-api-day07
docker logs -f devops-api-day07
docker logs -t devops-api-day07
```

## Inspect

```bash
docker inspect devops-api-day07
docker inspect -f '{{json .Mounts}}' devops-api-day07
docker inspect -f '{{range .NetworkSettings.Networks}}{{println .IPAddress}}{{end}}' devops-api-day07
```

## Exec

```bash
docker exec -it devops-api-day07 sh
```

Inside the container:

```sh
printenv
ls -la /data
cat /data/items.json
exit
```

## Healthcheck

```bash
docker ps
docker inspect -f '{{json .State.Health}}' devops-api-day07
```

## Volume

```bash
docker volume create devops-api-data-day07
docker volume ls
docker volume inspect devops-api-data-day07
```

## Network

```bash
docker network create devops-api-net-day07
docker network ls
docker network inspect devops-api-net-day07
```

## Container-to-container call

```bash
docker run --rm \
  --network devops-api-net-day07 \
  node:20-alpine \
  node -e "require('http').get('http://devops-api-day07:3000/health', res => { let d=''; res.on('data', c => d+=c); res.on('end', () => console.log(d)); })"
```

## Cleanup

```bash
docker rm -f devops-api-day07
docker network rm devops-api-net-day07
docker volume rm devops-api-data-day07
```