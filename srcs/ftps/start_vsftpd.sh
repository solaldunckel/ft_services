#!/bin/sh
mkdir -p /ftps/$FTP_USER
adduser -h /ftps/$FTP_USER -s /sbin/nologin -D $FTP_USER
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
chown -R $FTP_USER:$FTP_USER /ftps/$FTP_USER
chmod a-w /ftps/$FTP_USER

# Used to run custom commands inside container
if [ ! -z "$1" ]; then
  exec "$@"
else
  exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
fi
