FROM alpine:latest

RUN apk add --no-cache mysql mysql-client

COPY scripts/start.sh /start.sh
COPY files/my.cnf /etc/mysql/my.cnf

RUN mkdir -p /run/mysqld

WORKDIR /db
VOLUME /db
EXPOSE 3306

HEALTHCHECK CMD ["mysqladmin", "ping"]
CMD ["/start.sh"]
