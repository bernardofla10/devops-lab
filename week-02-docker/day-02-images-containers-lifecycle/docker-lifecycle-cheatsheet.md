# Docker Lifecycle Cheatsheet

## Image Lifecycle

### Pull an Image

```bash
docker pull nginx:alpine
```

### List Images

```bash
docker images
```

### Inspect an Image

```bash
docker image inspect nginx:alpine
```

### Remove an Image

```bash
docker rmi nginx:alpine
```

---

## Container Lifecycle

### Create a Container Without Starting It

```bash
docker create --name lifecycle-nginx -p 8082:80 nginx:alpine
```

### Start a Container

```bash
docker start lifecycle-nginx
```

### Create and Start a Container

```bash
docker run -d --name lifecycle-nginx -p 8082:80 nginx:alpine
```

### Stop a Container

```bash
docker stop lifecycle-nginx
```

### Restart a Container

```bash
docker restart lifecycle-nginx
```

### Pause a Container

```bash
docker pause lifecycle-nginx
```

### Resume a Paused Container

```bash
docker unpause lifecycle-nginx
```

### Remove a Stopped Container

```bash
docker rm lifecycle-nginx
```

### Force Remove a Container

```bash
docker rm -f lifecycle-nginx
```

---

## Inspecting Containers

### List Running Containers

```bash
docker ps
```

### List All Containers

```bash
docker ps -a
```

### Inspect a Container

```bash
docker inspect lifecycle-nginx
```

### Show Only the Container Status

```bash
docker inspect -f '{{.State.Status}}' lifecycle-nginx
```

### View Container Logs

```bash
docker logs lifecycle-nginx
docker logs --tail 20 lifecycle-nginx
docker logs -f lifecycle-nginx
```

### View Running Processes Inside a Container

```bash
docker top lifecycle-nginx
```

### View Resource Usage

```bash
docker stats lifecycle-nginx
docker stats --no-stream lifecycle-nginx
```

---

## Copying Files

### Host → Container

```bash
docker cp host-file.txt lifecycle-nginx:/tmp/host-file.txt
```

### Container → Host

```bash
docker cp lifecycle-nginx:/usr/share/nginx/html/index.html ./container-index.html
```

---

## Important Difference

- `docker create` — Creates a container without starting it.
- `docker start` — Starts an existing container.
- `docker run` — Creates **and** starts a new container.
- `docker exec` — Runs a command inside an already running container.

---

## Container States

Common container states:

- `created`
- `running`
- `paused`
- `exited`
- `restarting`
- `dead`