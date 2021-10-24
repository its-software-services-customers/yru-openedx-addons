#!/bin/bash

NS=velero

echo "####"
echo "#### Deploying velero to [${NS}] ####"

kubectl create ns ${NS}
kubectl apply -f rendered-velero.yaml -n ${NS}
