#!/bin/bash

NS=memcached

echo "####"
echo "#### Deploying memcached to [${NS}] ####"

kubectl apply -f rendered-memcached.yaml -n ${NS}
