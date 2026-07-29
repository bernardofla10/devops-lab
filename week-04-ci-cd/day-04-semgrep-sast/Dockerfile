# syntax=docker/dockerfile:1

FROM node:24-alpine

LABEL org.opencontainers.image.title="Semgrep SAST Lab"
LABEL org.opencontainers.image.description="Node.js API protected by a Semgrep security gate"

WORKDIR /app

COPY app/package.json app/package-lock.json ./

RUN npm ci --omit=dev \
    && npm cache clean --force

COPY --chown=node:node app/src ./src

ENV NODE_ENV=production
ENV APP_NAME=semgrep-sast-lab
ENV APP_ENV=production
ENV PORT=3000

EXPOSE 3000

USER node

CMD ["node", "src/server.js"]