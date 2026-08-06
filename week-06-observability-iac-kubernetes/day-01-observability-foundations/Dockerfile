# syntax=docker/dockerfile:1

FROM node:24-alpine

ARG BUILD_VERSION=local
ARG BUILD_REVISION=unknown

LABEL org.opencontainers.image.title="Observability Foundations API"
LABEL org.opencontainers.image.description="Logs, health checks and Prometheus metrics lab"
LABEL org.opencontainers.image.version="${BUILD_VERSION}"
LABEL org.opencontainers.image.revision="${BUILD_REVISION}"

WORKDIR /app

COPY app/package.json app/package-lock.json ./

RUN npm ci \
      --omit=dev \
      --ignore-scripts \
    && npm cache clean --force

COPY --chown=node:node app/src ./src

ENV NODE_ENV=production
ENV APP_NAME=observability-foundations-api
ENV APP_ENV=production
ENV APP_VERSION="${BUILD_VERSION}"
ENV APP_REVISION="${BUILD_REVISION}"
ENV STARTUP_DELAY_MS=3000
ENV PORT=3000

EXPOSE 3000

HEALTHCHECK \
  --interval=5s \
  --timeout=2s \
  --start-period=5s \
  --retries=5 \
  CMD node -e "require('http').get('http://localhost:3000/health', response => process.exit(response.statusCode === 200 ? 0 : 1)).on('error', () => process.exit(1))"

USER node

CMD ["node", "src/server.js"]