#!/bin/sh
mkdir -p /ftps/$FTP_USER

adduser -h /ftps/$FTP_USER -s /sbin/nologin -D $FTP_USER
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
chown -R $FTP_USER:$FTP_USER /ftps/$FTP_USER

exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd-tmp.conf
