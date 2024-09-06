#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: deploy.sh version"
    echo "    example: deploy.sh  1.0.0"
    exit 1
fi

echo "Deployment is started with version $1 "

echo "Build ratel-server ======================="
cd ./../ratel-server/
git checkout $1
git pull
mvn package -DskipTests
echo "Build ratel-web ======================="
cd ./../ratel-web/
git restore package.json
git restore package-lock.json
git checkout $1
git pull
. ~/.nvm/nvm.sh
nvm use 20
npm install
npm run prod:build
cd ..
echo "Build docker image ======================="
cd ratel-deployment/
git checkout $1
git pull
./prepare.sh $1
docker build -t ratel-allinone:1.0.0 -f Dockerfile-allinone .
docker stop ratel
docker rm ratel
docker run -d --name ratel --restart=always -p 3306:3306 -p 6379:6379 -p 8000:8000 -p 8080:8080 -p 8081:8081 -p 9000:9000 -p 9001:9001 -e PROFILE=prod -v ~/works/ratel/config:/works/config -v ~/works/ratel/logs:/opt/logs -v ~/works/ratel/minio:/opt/minio/data     ratel-allinone:1.0.0
