#!/bin/sh

if [ -d /db/mysql ]; then
  echo "[i] MySQL directory already present, skipping creation"
else
  echo "[i] MySQL data directory not found, creating initial DBs"

  if [ "$MYSQL_ROOT_PASSWORD" = "" ]; then
    echo '[e] $MYSQL_ROOT_PASSWORD missing.'
    exit 1
  else
    echo "[i] MySQL root Password: $MYSQL_ROOT_PASSWORD"
  fi

  mysql_install_db --user=root > /dev/null

  MYSQL_DATABASE=${MYSQL_DATABASE:-""}
  MYSQL_USER=${MYSQL_USER:-""}
  MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

  tfile=`mktemp`
  if [ ! -f "$tfile" ]; then
      return 1
  fi

  cat << EOF > $tfile
USE mysql;
CREATE DATABASE $MYSQL_DATABASE;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD" WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
UPDATE user SET password=PASSWORD("") WHERE user='root' AND host='localhost';
EOF

  /usr/bin/mysqld --user=root --bootstrap --verbose=0 < $tfile
  rm -f $tfile
fi

exec /usr/bin/mysqld --user=root --console
