#!/bin/bash

NS=cert-manager

echo ""
echo "### Setting up cert-manager in namespae [${NS}] ###"

kubectl create ns ${NS}
kubectl apply -f rendered-cert-manager.yaml
