FROM node:20-alpine

LABEL maintainer="Bernardo de Castro"
LABEL description="Scalable Node.js API for Docker Compose recovery lab"

WORKDIR /app

COPY app/package.json app/package-lock.json ./

RUN npm ci --omit=dev

COPY app/server.js ./server.js

ENV APP_NAME=scalable-compose-api
ENV APP_ENV=production
ENV PORT=3000

EXPOSE 3000

USER node

CMD ["npm", "start"]