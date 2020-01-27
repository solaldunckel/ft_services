FROM alpine:latest

RUN apk upgrade --update-cache --available && \
	apk --no-cache add vsftpd

COPY scripts/start.sh /bin/start.sh
COPY files/vsftpd-tmp.conf /etc/vsftpd/vsftpd-tmp.conf

COPY files/vsftpd.key /etc/vsftpd/vsftpd.key
COPY files/vsftpd.crt /etc/vsftpd/vsftpd.crt

VOLUME /ftps
EXPOSE 21 21000-21010

ENTRYPOINT ["/bin/start.sh"]
