FROM node:20-alpine

LABEL maintainer="Bernardo de Castro"
LABEL description="Final Docker fundamentals lab: containerized API"

WORKDIR /app

COPY app/package.json ./package.json
COPY app/server.js ./server.js

RUN mkdir -p /data

ENV APP_NAME=containerized-api
ENV APP_ENV=production
ENV PORT=3000
ENV DATA_DIR=/data

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', res => process.exit(res.statusCode === 200 ? 0 : 1)).on('error', () => process.exit(1))"

CMD ["npm", "start"]