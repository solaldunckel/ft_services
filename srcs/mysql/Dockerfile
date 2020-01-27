FROM alpine:latest
MAINTAINER leafney "babycoolzx@126.com"

RUN apk update && \
	apk add mysql mysql-client && \
	addgroup mysql mysql && \
	mkdir /scripts && \
	rm -rf /var/cache/apk/*

VOLUME ["/var/lib/mysql"]

COPY scripts/start.sh /scripts/start.sh
COPY files/my.cnf /etc/mysql/my.cnf
RUN chmod +x /scripts/start.sh

EXPOSE 3306

ENTRYPOINT ["/scripts/start.sh"]
