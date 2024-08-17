#!/bin/bash

echo "Build ratel-server ======================="
cd ./../ratel-server/
git pull
mvn package -DskipTests
echo "Build ratel-web ======================="
cd ./../ratel-web/
git restore package.json
git restart package-lock.json
git pull
nvm use 20
npm install
npm run prod:build
cd ..
echo "Build docker image ======================="
cd ratel-deployment/
git pull
./prepare.sh
docker build -t ratel-allinone:1.0.0 -f Dockerfile-allinone .
docker stop ratel
docker rm ratel
docker run -d --name ratel --restart=always -p 3306:3306 -p 6379:6379 -p 8000:8000 -p 8080:8080 -p 8081:8081 -p 9000:9000 -p 9001:9001 -e PROFILE=prod -v ~/works/ratel/config:/works/config -v ~/works/ratel/logs:/opt/logs -v ~/works/ratel/minio:/opt/minio/data     ratel-allinone:1.0.0
