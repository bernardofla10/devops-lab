# Define a imagem base do Node.js
FROM node:20-alpine 

LABEL maintainer="Bernardo de Castro"
LABEL description=

# Define a pasta de trabalho dentro do container
WORKDIR /app

# Copia app para dentro da imagem
COPY app/package.json ./package.json
COPY app/server.js ./server.js

# Expõe a porta 3000 para que a aplicação possa receber tráfego
EXPOSE 3000

# Define o comando padrão para iniciar a aplicação
CMD ["npm", "start"]