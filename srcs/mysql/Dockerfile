FROM alpine:latest

ENV MYSQL_ROOT_PASSWORD root
ENV MYSQL_DATABASE app
ENV MYSQL_USER app
ENV MYSQL_PASSWORD app
ENV MYSQL_USER_MONITORING monitoring
ENV MYSQL_PASSWORD_MONITORING monitoring

RUN apk add --no-cache mysql
RUN addgroup mysql mysql

WORKDIR /app

COPY startup.sh /startup.sh

# Creating the persistent volume
VOLUME [ "/var/lib/mysql" ]

EXPOSE 3306

ENTRYPOINT	 ["./startup.sh"]
