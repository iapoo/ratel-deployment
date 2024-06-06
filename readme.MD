
docker build -t ratel-basic:1.0.0 -f Dockerfile-basic .

docker build -t ratel-allinone:1.0.0 -f Dockerfile-allinone .

docker run -d --name ratel -p 3306:3306 -p 6379:6379 -p 8000:8000 -p 8080:8080 -p 8081:8081 -p 9000:9000 -p 9001:9001   ratel-allinone:1.0.0

docker exec -it ratel sh