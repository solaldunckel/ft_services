FROM alpine:latest

RUN apk --no-cache add vsftpd && \
	apk add openssl

COPY start_vsftpd.sh /start_vsftpd.sh
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75/L=Paris/O=42/CN=sdunckel' -keyout /etc/vsftpd/vsftpd.key -out /etc/vsftpd/vsftpd.crt

EXPOSE 20 21 21000-21010

ENTRYPOINT ["/start_vsftpd.sh"]
