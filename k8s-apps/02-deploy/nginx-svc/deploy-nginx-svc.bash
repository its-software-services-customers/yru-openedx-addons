#!/bin/bash

NS=ingress-nginx

echo "####"
echo "#### Deploying basic resources ####"

kubectl apply -f nginx-svc.yaml -n ${NS}

kubectl set resources deployment default-http-backend -c=default-http-backend --limits=cpu=200m -n ${NS}
