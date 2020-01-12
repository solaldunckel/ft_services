#!/bin/sh

touch /var/log/vsftpd.log

if [ -z "$FTP_USER" ]; then
  FTP_USER="admin"
  FTP_PASS="admin"
fi

FOLDER="/ftps/$FTP_USER"

mkdir -p /ftps/$FTP_USER
echo -e "$FTP_PASS\n$FTP_PASS" | adduser -h $FOLDER -s /sbin/nologin $FTP_USER
chown -R $FTP_USER:$FTP_USER $FOLDER
chmod a-w $FOLDER

# Used to run custom commands inside container
if [ ! -z "$1" ]; then
  exec "$@"
else
  exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
fi
