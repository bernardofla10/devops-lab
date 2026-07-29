# Docker Build in GitHub Actions

## Buildx

```yaml
- name: Set up Docker Buildx
  uses: docker/setup-buildx-action@v4
```

## Metadata

```yaml
- name: Generate metadata
  uses: docker/metadata-action@v5
```

## Build check

```yaml
- name: Validate Dockerfile
  uses: docker/build-push-action@v7
  with:
    call: check
```

## Build and load

```yaml
- name: Build image
  uses: docker/build-push-action@v7
  with:
    load: true
    push: false
    tags: devops-ci-api:ci-test
```

## Cache

```yaml
cache-from: type=gha,scope=week04-day03
cache-to: type=gha,mode=max,scope=week04-day03
```

## Build arguments

```yaml
build-args: |
  BUILD_VERSION=sha-${{ github.sha }}
  BUILD_REVISION=${{ github.sha }}
```

## Runtime test

```bash
docker run -d \
  --name api-test \
  -p 127.0.0.1:18080:3000 \
  devops-ci-api:ci-test
```

## Health status

```bash
docker inspect \
  -f '{{.State.Health.Status}}' \
  api-test
```

## Export image

```bash
docker save devops-ci-api:ci-test |
  gzip > devops-ci-api.tar.gz
```

## Load exported image

```bash
gunzip --stdout devops-ci-api.tar.gz |
  docker load
```

## Build versus push

```text
docker build / buildx build
  creates an image

docker push
  uploads an image to a registry
```

## Important rule

A successful image build does not prove that the application works.

The pipeline should also test:

- process startup
- healthcheck
- application endpoints
- expected error behavior
- image portability