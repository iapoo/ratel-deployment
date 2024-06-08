#!/bin/bash

# clean history
rm -f /tmp/*.pid

# start nginx server
service nginx start

# start minio server
#export MINIO_ROOT_USER=admin
#export MINIO_ROOT_PASSWORD=password
nohup /opt/minio/minio server /opt/minio/data --console-address ":9001" &

sleep 3s

if [ ! -f "/opt/first_run" ]
then
    /opt/minio/mc alias set myminio http://localhost:9000 admin password
    /opt/minio/mc mb --with-lock myminio/ratel-rockie-dev
    #/opt/minio/mc admin user add local minio password
fi

# start redis server
service redis-server start

# start mysql
if [ ! -f "/opt/first_run" ]
then
    chown -R mysql:mysql /var/lib/mysql 
    chmod 1777 /var/lib/mysql
    usermod -d /var/lib/mysql/ mysql
    #FIX ME, don't work for mysql yet
    #groupadd -r mysql && useradd -r -g mysql mysql
    #chown -R mysql:mysql ~/works/ratel/mysql 
    #chmod 1777 ~/works/ratel/mysql

fi

service mysql start


# wait for starting hadoop server successfully
sleep 4s

if [ ! -f "/opt/first_run" ]
then
    echo "Initialize database environment"
    mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'password' PASSWORD EXPIRE NEVER; ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';  UPDATE mysql.user SET host = '%' WHERE user = 'root';FLUSH PRIVILEGES;"
    echo "Create database: ratel"
    mysql -uroot -ppassword  < /opt/ratel-system-server/scripts/create-schema.sql
    echo "Initialize database ratel: system"
    mysql -uroot -ppassword  < /opt/ratel-system-server/scripts/create-tables.sql
    echo "Initialize database ratel: rockie"
    mysql -uroot -ppassword  < /opt/ratel-rockie-server/scripts/create-tables.sql
fi

# wait for starting hadoop server successfully
sleep 2s


# start ratel-system-server
nohup java $JVM_OPTS -Dspring.profiles.active=$PROFILE -Djava.security.egd=file:/dev/./urandom -jar /opt/ratel-system-server/ratel-system-server-1.0.0.jar &

# start ratel-rockie-server
nohup java $JVM_OPTS -Dspring.profiles.active=$PROFILE -jar /opt/ratel-rockie-server/ratel-rockie-server-1.0.0.jar &


touch /opt/first_run

while :
do
    sleep 1
done
