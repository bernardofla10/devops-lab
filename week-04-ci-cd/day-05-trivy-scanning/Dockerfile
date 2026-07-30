# syntax=docker/dockerfile:1

FROM node:24.18.1-alpine

# npm 11.16 bundles tar 7.5.15, which Trivy reports as affected by
# CVE-2026-59873. npm 12.0.2 upgrades the bundled tar dependency to 7.5.19.
RUN npm install --global npm@12.0.2 --ignore-scripts \
    && npm cache clean --force

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
