# Dockerfile Cheatsheet

## Basic Dockerfile structure

```dockerfile
FROM nginx:alpine

WORKDIR /usr/share/nginx/html

COPY html/index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

## Important instructions

## FROM

Defines the base image.

```dockerfile
FROM nginx:alpine
```

## LABEL

Adds metadata to the image.

```dockerfile
LABEL maintainer="Bernardo de Castro"
LABEL description="Custom Docker image"
```

## WORKDIR

Sets the working directory inside the image/container.

```dockerfile
WORKDIR /app
```

## COPY

Copies files from the build context into the image.

```dockerfile
COPY html/index.html /usr/share/nginx/html/index.html
```

## RUN

Runs commands during image build.

```dockerfile
RUN apk add --no-cache curl
```

## EXPOSE

Documents the port used by the container.

```dockerfile
EXPOSE 80
```

Important: `EXPOSE` does not publish the port automatically. Use `docker run -p`.

## CMD

Defines the default command when the container starts.

```dockerfile
CMD ["nginx", "-g", "daemon off;"]
```

## Build image

```bash
docker build -t devops-nginx:day03 .
```

## Run image

```bash
docker run -d --name dockerfile-nginx -p 8083:80 devops-nginx:day03
```

## Inspect image

```bash
docker image inspect devops-nginx:day03
docker history devops-nginx:day03
```

## Tag image

```bash
docker tag devops-nginx:day03 devops-nginx:latest
```

## Remove image

```bash
docker rmi devops-nginx:day03
```

## Build context

The final `.` in this command is the build context:

```bash
docker build -t devops-nginx:day03 .
```

Docker can only copy files that are inside the build context.

## .dockerignore

`.dockerignore` prevents unnecessary or sensitive files from being sent to the Docker build context.

Never include:

- `.env`
- private keys
- tokens
- cloud credentials
- large unnecessary directories
- logs