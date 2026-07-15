# Docker Basics - Day 01

## What Is Docker?

Docker is a platform used to build, package, and run applications in containers.

## Image

An image is a packaged template used to create containers.

Examples:

- `hello-world`
- `alpine:latest`
- `nginx:alpine`

## Container

A container is a running or stopped instance of an image.

## Image vs Container

```text
Image     = Template / Package
Container = Running or stopped instance
```

## Registry

A registry stores Docker images.

**Docker Hub** is a common public registry.

---

## Important Commands

### Docker Version

```bash
docker --version
docker version
docker info
```

### Run a Container

```bash
docker run hello-world
docker run alpine:latest echo "Hello from Alpine"
docker run -it alpine:latest sh
```

### List Containers

```bash
docker ps
docker ps -a
```

### List Images

```bash
docker images
```

### Run Nginx

```bash
docker run -d --name nginx-day01 -p 8081:80 nginx:alpine
```

### View Logs

```bash
docker logs nginx-day01
docker logs -f nginx-day01
```

### Execute a Command Inside a Running Container

```bash
docker exec -it nginx-day01 sh
```

### Stop, Start, and Remove a Container

```bash
docker stop nginx-day01
docker start nginx-day01
docker rm nginx-day01
```

---

## Port Mapping

```text
-p 8081:80
```

Means:

```text
Host port 8081 → Container port 80
```

---

## Detached Mode

```text
-d
```

Runs the container in the background.

---

## Remove After Exit

```text
--rm
```

Automatically removes the container after it exits.

---

## Key Lesson

- `docker run` creates a **new container** from an image.
- `docker exec` runs a command **inside an existing running container**.