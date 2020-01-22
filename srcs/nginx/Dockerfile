FROM nginx:alpine

RUN apk upgrade --update-cache --available && \
    apk add openssl && \
	apk add openssh && \
    rm -rf /var/cache/apk/*

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75/L=Paris/O=42/CN=sdunckel' -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt

COPY files/nginx.conf /etc/nginx/nginx.conf
COPY scripts/start.sh /start.sh
COPY files/index.html /usr/share/nginx/html

EXPOSE 80 443
ENTRYPOINT sh /start.sh
