#!/bin/bash

echo ""
echo "### Setup MinIO ###"

NS=minio-operator
VERSION=v4.2.10
GIT_URL=https://github.com/minio/operator/?ref=${VERSION}

kubectl apply -k ${GIT_URL}

OUTPUT_FILE=minio-console-ing.yaml
sed -i "s#<<VAR_CERT_CLUSTER_DOMAIN>>#${VAR_PROMETHEUS_SECRET_PROJECT}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

