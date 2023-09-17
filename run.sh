#!/bin/sh


cd /home/minno/Documents/SchedulePlatform-searchIndex/searchIndex

mvn clean package

mkdir -p /home/minno/Documents/glassfish7-docker/autodeploy/

cp ./target/searchIndex.war /home/minno/Documents/glassfish7-docker/autodeploy/searchIndex.war

cd /home/minno/Documents/glassfish7-docker

./build.sh 

docker run --rm -p 8080:8080 --network EZCampus \
   -v "./autodeploy":/opt/app/glassfish7/glassfish/domains/domain1/autodeploy \
   -e DB_USER="test" \
   -e DB_PASSWORD="root" \
   -e DB_HOST="mysql-instance" \
   -e DB_NAME="hibernate_db" \
   -e DB_PORT="3306" \
   glassfish7:latest




