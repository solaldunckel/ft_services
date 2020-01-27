FROM nginx:alpine

RUN apk upgrade --update-cache --available && \
    apk add openrc openssl openssh-server && \
	rc-update add sshd && \
    rm -rf /var/cache/apk/*

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75/L=Paris/O=42/CN=sdunckel' -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt

COPY files/nginx.conf /etc/nginx/nginx.conf
COPY scripts/start.sh /start.sh
COPY files/index.html /usr/share/nginx/html

COPY files/ssh_host_dsa_key /etc/ssh
COPY files/ssh_host_dsa_key.pub /etc/ssh
COPY files/ssh_host_rsa_key /etc/ssh
COPY files/ssh_host_rsa_key.pub /etc/ssh

EXPOSE 22 80 443
ENTRYPOINT sh /start.sh
