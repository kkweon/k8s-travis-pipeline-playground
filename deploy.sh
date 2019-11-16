#!/usr/bin/env bash
docker build                  \
-t kkweon/multi-client:latest \
-t kkweon/multi-client:$SHA   \
-f ./client/Dockerfile ./client
docker build                  \
-t kkweon/multi-server:latest \
-t kkweon/multi-server:$SHA   \
-f ./server/Dockerfile ./server
docker build                  \
-t kkweon/multi-worker:latest \
-t kkweon/multi-worker:$SHA   \
-f ./worker/Dockerfile ./worker

docker push kkweon/multi-client:latest
docker push kkweon/multi-server:latest
docker push kkweon/multi-worker:latest

docker push kkweon/multi-client:$SHA
docker push kkweon/multi-server:$SHA
docker push kkweon/multi-worker:$SHA

kubectl apply -f k8s:$SHA
kubectl set image deployments/client-deployment client=kkweon/multi-client:$SHA
kubectl set image deployments/server-deployment server=kkweon/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=kkweon/multi-worker:$SHA
