#!/bin/bash
if [ $# -lt 1 ]; then
    echo "Usage: prepare.sh version"
    echo "    example: prepare.sh  1.0.0"
    exit 1
fi


echo "Preparement is started with version $1 "

#Prepare directories
echo "==============================================="
echo "Prepare directories"
mkdir apps
mkdir config
mkdir dist
mkdir -p scripts/ratel-system-server
mkdir -p scripts/ratel-rockie-server

#Prepare minio, uncomment can update minio
echo "==============================================="
echo "Prepare minio, uncomment can update minio"
if [ ! -f "apps/minio" ]
then
    wget -O apps/minio https://dl.min.io/server/minio/release/linux-amd64/minio
    chmod +x apps/minio
fi
if [ ! -f "apps/mc" ]
then
    wget -O apps/mc https://dl.min.io/client/mc/release/linux-amd64/mc
    chmod +x apps/mc
fi

#Prepare ratel applications
echo "==============================================="
echo "Prepare ratel applications"
cp -f ./../ratel-server/ratel-system-server/target/ratel-system-server-$1.jar apps/
cp -f ./../ratel-server/ratel-rockie-server/target/ratel-rockie-server-$1.jar apps/

#Prepare config
echo "==============================================="
echo "Prepare config"
rm -rf config/*
cp -r ./../ratel-server/config/* config/

#Prepare web content
echo "==============================================="
echo "Prepare web content"
rm -rf dist/*
cp -r ./../ratel-web/app/dist/* dist/

#Prepare database scripts
echo "==============================================="
echo "Prepare web content"
cp ./../ratel-server/ratel-system-domain/scripts/mysql/create-schema.sql scripts/ratel-system-server/
cp ./../ratel-server/ratel-system-domain/scripts/mysql/create-tables.sql scripts/ratel-system-server/
cp ./../ratel-server/ratel-rockie-domain/scripts/mysql/create-tables.sql scripts/ratel-rockie-server/
