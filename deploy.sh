#!/bin/bash

if [ $# -lt 3 ]; then
    echo "Usage: deploy.sh env branch version"
    echo "    example: deploy.sh prod main 1.0.0"
    echo "    env can be prod, local, docker, electron"
    exit 1
fi

web_build="docker:build"

case $1 in
    "prod")
        web_build="prod:build"
    ;;
    "local")
        web_build="build"
    ;;
    "docker")
        web_build="docker:build"
    ;;
    "electron")
        web_build="electron:build"
    ;;
    *)
        web_build="build"
    ;;
esac

echo "Deployment is started with env=$1 branch= $2 version=$3 "

echo "Build ratel-server ======================="
cd ./../ratel-server/
git checkout $2
git pull
mvn clean package -DskipTests
echo "Build ratel-web ======================="
cd ./../ratel-web/
git restore package.json
git restore package-lock.json
git checkout $2
git pull
. ~/.nvm/nvm.sh
nvm use 20
npm install
npm run $web_build
cd ..
echo "Build docker image ======================="
cd ratel-deployment/
git checkout $2
git pull
./prepare.sh $1 $2 $3
docker build -t ratel-allinone:$3  -f Dockerfile-allinone  --build-arg RATEL_VERSION=$3  .
docker stop ratel
docker rm ratel
docker run -d --name ratel --restart=always -p 3306:3306 -p 6379:6379 -p 8000:8000 -p 8080:8080 -p 8081:8081 -p 9000:9000 -p 9001:9001 -e PROFILE=prod -v ~/works/ratel/config:/works/config -v ~/works/ratel/logs:/opt/logs -v ~/works/ratel/minio:/opt/minio/data     ratel-allinone:$3
