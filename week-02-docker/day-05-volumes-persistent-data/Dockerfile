FROM node:20-alpine

LABEL maintainer="Bernardo de Castro"
LABEL description="Node.js app for Docker volumes and persistent data lab"

WORKDIR /app

COPY app/package.json ./package.json
COPY app/server.js ./server.js

# cria a pasta padrão de dados
RUN mkdir -p /data

ENV PORT=3000

# define onde a aplicação grava dados
ENV DATA_DIR=/data

EXPOSE 3000

CMD ["npm", "start"]