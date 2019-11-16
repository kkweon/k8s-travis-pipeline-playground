#!/usr/bin/env bash
docker build -t kkweon/multi-client -f ./client/Dockerfile ./client
docker build -t kkweon/multi-server -f ./server/Dockerfile ./server
docker build -t kkweon/multi-worker -f ./worker/Dockerfile ./worker

docker push kkweon/multi-client
docker push kkweon/multi-server
docker push kkweon/multi-worker

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=kkweon/multi-server