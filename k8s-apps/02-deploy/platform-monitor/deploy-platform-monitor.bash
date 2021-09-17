#!/bin/bash

NS=platform-monitor

echo "####"
echo "#### Deploying platform monitoring to [${NS}] ####"

kubectl create ns ${NS}
kubectl apply -f rendered-prometheus-stack.yaml -n ${NS}

#Use this for debug only
OUTPUT_FILE=prometheus-ing.yaml
sed -i "s#<<VAR_CERT_CLUSTER_DOMAIN>>#${VAR_CERT_CLUSTER_DOMAIN}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}
