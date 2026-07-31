# syntax=docker/dockerfile:1

FROM node:24.18.1-alpine

# npm 11.16 bundles tar 7.5.15, which is affected by CVE-2026-59873.
# npm 12.0.2 upgrades the bundled tar dependency to the fixed 7.5.19.
RUN npm install --global npm@12.0.2 --ignore-scripts \
    && npm cache clean --force

ARG BUILD_VERSION=local
ARG BUILD_REVISION=unknown

LABEL org.opencontainers.image.title="Final DevSecOps API"
LABEL org.opencontainers.image.description="Application for the final Week 04 CI/CD and security pipeline"
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
ENV APP_NAME=final-devsecops-api
ENV APP_ENV=production
ENV APP_VERSION="${BUILD_VERSION}"
ENV APP_REVISION="${BUILD_REVISION}"
ENV PORT=3000

EXPOSE 3000

HEALTHCHECK \
  --interval=3s \
  --timeout=2s \
  --start-period=3s \
  --retries=10 \
  CMD node -e "require('http').get('http://localhost:3000/ready', response => process.exit(response.statusCode === 200 ? 0 : 1)).on('error', () => process.exit(1))"

USER node

CMD ["node", "src/server.js"]
