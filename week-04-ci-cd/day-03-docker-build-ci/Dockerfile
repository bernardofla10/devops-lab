# syntax=docker/dockerfile:1

FROM node:24-alpine

# Recebem metadados durante o build.
ARG BUILD_VERSION=local
ARG BUILD_REVISION=unknown

# Armazenam metadados na imagem.
LABEL org.opencontainers.image.title="Docker CI API"
LABEL org.opencontainers.image.description="Node.js API for Docker build CI lab"
LABEL org.opencontainers.image.version="${BUILD_VERSION}"
LABEL org.opencontainers.image.revision="${BUILD_REVISION}"

WORKDIR /app

COPY app/package.json app/package-lock.json ./

RUN npm ci --omit=dev \
    && npm cache clean --force

COPY --chown=node:node app/src ./src

ENV NODE_ENV=production
ENV APP_NAME=docker-ci-api
ENV APP_ENV=production
ENV APP_VERSION="${BUILD_VERSION}"
ENV APP_REVISION="${BUILD_REVISION}"
ENV PORT=3000

EXPOSE 3000

# O Docker executará periodicamente GET http://localhost:3000/health
HEALTHCHECK \
  --interval=2s \
  --timeout=2s \
  --start-period=3s \
  --retries=10 \
  CMD node -e "require('http').get('http://localhost:3000/health', response => process.exit(response.statusCode === 200 ? 0 : 1)).on('error', () => process.exit(1))"

# A aplicação não precisa executar como root: usuário não root
USER node

CMD ["node", "src/server.js"]