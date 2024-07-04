# Ratel Deployment

## About Ratel Deployment

Ratel Deployment is deployment tools of Ratel. Ratel is general diagram editor. There are 3 sub projects: Ratel-Web(frontend), Ratel-Server(backend) and Ratel-deployment(deployment)

## Try

### Try online demo

Try onelin demo.

### Try all-in-one docker image locally

docker run -d --name ratel -p 3306:3306 -p 6379:6379 -p 8000:8000 -p 8080:8080 -p 8081:8081 \
    -p 9000:9000 -p 9001:9001 -v ~/works/ratel/logs:/opt/logs -v ~/works/ratel/minio:/opt/minio/data \
    topoo/ratel-allinone:0.1

### Try all-in-one docker

Pleae check Ratel-Deployment

## Build

### Prepare

It requires Ratel Web & Ratel Server are under the same folder of Ratel Deployment.
Then Prepare artifacts: ./prepare.sh

### Build Docker images

#### Build basic image first

docker build -t ratel-basic:1.0.0 -f Dockerfile-basic .

#### Build all-in-one image

docker build -t ratel-allinone:1.0.0 -f Dockerfile-allinone .

#### Run docker container.

docker run -d --name ratel -p 3306:3306 -p 6379:6379 -p 8000:8000 -p 8080:8080 -p 8081:8081 \
    -p 9000:9000 -p 9001:9001 ratel-allinone:1.0.0

#### Run docker container by mount data(logs & minio) locally.

docker run -d --name ratel -p 3306:3306 -p 6379:6379 -p 8000:8000 -p 8080:8080 -p 8081:8081 \
    -p 9000:9000 -p 9001:9001 -v ~/works/ratel/logs:/opt/logs -v ~/works/ratel/minio:/opt/minio/data \
    ratel-allinone:1.0.0

#### Run docker container by mount data(logs & minio & mysql) locally. It may fail

docker run -d --name ratel -p 3306:3306 -p 6379:6379 -p 8000:8000 -p 8080:8080 -p 8081:8081 \
    -p 9000:9000 -p 9001:9001 -v ~/works/ratel/logs:/opt/logs -v ~/works/ratel/minio:/opt/minio/data \
    -v ~/works/ratel/mysql:/var/lib/mysql  ratel-allinone:1.0.0

#### Tuning

docker exec -it ratel sh
