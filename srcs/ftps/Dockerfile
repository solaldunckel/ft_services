FROM alpine:latest

RUN apk upgrade --update-cache --available && \
	apk --no-cache add vsftpd

COPY scripts/start.sh /bin/start.sh
COPY files/vsftpd-target.conf /etc/vsftpd/vsftpd-target.conf

COPY files/vsftpd.key /etc/vsftpd/vsftpd.key
COPY files/vsftpd.crt /etc/vsftpd/vsftpd.crt

VOLUME /ftps
EXPOSE 21 21000-21010

ENTRYPOINT ["/bin/start.sh"]
