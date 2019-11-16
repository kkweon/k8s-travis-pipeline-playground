#!/usr/bin/env bash
GIT_SHA=$(git rev-parse HEAD)
docker build                    \
-t kkweon/multi-client:latest   \
-t kkweon/multi-client:$GIT_SHA \
-f ./client/Dockerfile ./client
docker build                    \
-t kkweon/multi-server:latest   \
-t kkweon/multi-server:$GIT_SHA \
-f ./server/Dockerfile ./server
docker build                    \
-t kkweon/multi-worker:latest   \
-t kkweon/multi-worker:$GIT_SHA \
-f ./worker/Dockerfile ./worker

docker push kkweon/multi-client
docker push kkweon/multi-server
docker push kkweon/multi-worker

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=kkweon/multi-server