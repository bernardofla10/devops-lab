FROM nginx:alpine

LABEL maintainer="Bernardo de Castro"
LABEL description="Custom Nginx image for DevOps Lab - Dockerfile basics"

WORKDIR /usr/share/nginx/html

COPY html/index.html /usr/share/nginx/html/index.html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]