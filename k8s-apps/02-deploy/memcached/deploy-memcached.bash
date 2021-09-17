#!/bin/bash

NS=memcached

echo "####"
echo "#### Deploying memcached to [${NS}] ####"

kubectl create ns ${NS}
kubectl apply -f rendered-memcached.yaml -n ${NS}
