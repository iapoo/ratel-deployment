#!/bin/bash

# clean history
rm -f /tmp/*.pid

# start redis server
service redis-server start

# start mysql
if [ ! -f "/opt/first_run" ]
then
    usermod -d /var/lib/mysql/ mysql
fi
service mysql start
if [ ! -f "/opt/first_run" ]
then
    mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'password' PASSWORD EXPIRE NEVER; ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';  UPDATE mysql.user SET host = '%' WHERE user = 'root';FLUSH PRIVILEGES;"
fi

# wait for starting hadoop server successfully
sleep 1s


touch /opt/first_run

while :
do
    sleep 1
done
