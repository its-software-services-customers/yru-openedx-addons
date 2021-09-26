#!/usr/bin/bash

NS=openedx

echo "####"
echo "#### Deploying openedx to [${NS}] ####"

kubectl create ns ${NS}

OUTPUT_FILE=openedx-ing.yaml
sed -i "s#<<VAR_CERT_CLUSTER_DOMAIN>>#${VAR_CERT_CLUSTER_DOMAIN}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}
