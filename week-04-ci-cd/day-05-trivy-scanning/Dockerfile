# syntax=docker/dockerfile:1

FROM node:24-alpine

LABEL org.opencontainers.image.title="Trivy Security Lab"
LABEL org.opencontainers.image.description="Node.js API protected by Trivy security gates"

WORKDIR /app

COPY app/package.json app/package-lock.json ./

RUN npm ci --omit=dev \
    && npm cache clean --force

COPY --chown=node:node app/src ./src

ENV NODE_ENV=production
ENV APP_NAME=trivy-security-lab
ENV APP_ENV=production
ENV PORT=3000

EXPOSE 3000

HEALTHCHECK \
  --interval=3s \
  --timeout=2s \
  --start-period=3s \
  --retries=10 \
  CMD node -e "require('http').get('http://localhost:3000/health', response => process.exit(response.statusCode === 200 ? 0 : 1)).on('error', () => process.exit(1))"

USER node

CMD ["node", "src/server.js"]