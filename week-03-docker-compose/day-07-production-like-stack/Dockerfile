FROM node:20-alpine

LABEL maintainer="Bernardo de Castro"
LABEL description="Production-like Node.js API for Docker Compose final lab"

WORKDIR /app

COPY app/package.json app/package-lock.json ./

RUN npm ci --omit=dev

COPY app/server.js ./server.js
COPY app/migrate.js ./migrate.js
COPY app/integration-test.js ./integration-test.js

COPY db/migrations ./migrations

ENV APP_NAME=production-like-api
ENV APP_ENV=production
ENV PORT=3000

EXPOSE 3000

USER node

CMD ["node", "server.js"]