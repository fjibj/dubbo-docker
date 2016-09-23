#!/bin/bash

set -e

docker run --rm --name my-maven-project -v "$PWD":/usr/src/mymaven -w /usr/src/mymaven maven mvn package

REG_URL=index.csphere.cn
IREG_URL=docker.nicescale.com
TAGS="2.5.3 2.5"
export BASE_IMAGE=tomcat:8-jre8-alpine

docker pull $BASE_IMAGE

IMAGE=microimages/dubbo-producer-demo
docker build -t $IMAGE service-producer
docker tag -f $IMAGE $REG_URL/$IMAGE
docker tag -f $IMAGE $IREG_URL/$IMAGE
for t in $TAGS; do
  docker tag -f $IMAGE $REG_URL/$IMAGE:$t
  docker tag -f $IMAGE $IREG_URL/$IMAGE:$t
  docker tag -f $IMAGE $IMAGE:$t
done
docker push $IMAGE
docker push $REG_URL/$IMAGE
docker push $IREG_URL/$IMAGE

IMAGE=microimages/dubbo-consumer-demo
docker build -t $IMAGE service-consumer
docker tag -f $IMAGE $REG_URL/$IMAGE
docker tag -f $IMAGE $IREG_URL/$IMAGE
for t in $TAGS; do
  docker tag -f $IMAGE $REG_URL/$IMAGE:$t
  docker tag -f $IMAGE $IREG_URL/$IMAGE:$t
  docker tag -f $IMAGE $IMAGE:$t
done
docker push $IMAGE
docker push $REG_URL/$IMAGE
docker push $IREG_URL/$IMAGE
