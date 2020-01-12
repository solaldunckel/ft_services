FROM nginx:alpine

RUN apk upgrade --update-cache --available && \
    apk add openssl && \
	apk add openssh && \
    rm -rf /var/cache/apk/*

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75/L=Paris/O=42/CN=sdunckel' -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 22 80 443

CMD ["nginx", "-g", "daemon off;"]
