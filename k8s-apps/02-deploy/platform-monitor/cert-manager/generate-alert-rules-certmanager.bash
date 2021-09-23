#!/bin/bash

OUTPUT_FILE=$1
CERT_MANAGER_MIXIN=cert-manager-mixin
NAME=certmanager-alert-rules

if [ -z "${OUTPUT_FILE}" ]
then
  OUTPUT_FILE=generated-certmanager-rules.yaml
fi

rm -rf ${CERT_MANAGER_MIXIN}
git clone https://gitlab.com/uneeq-oss/${CERT_MANAGER_MIXIN}.git

cat << 'EOF' > ${CERT_MANAGER_MIXIN}/config.libsonnet
{
  _config+:: {
    certManagerCertExpiryDays: '21',
    certManagerJobLabel: 'cluster-cert-manager',
    certManagerRunbookURLPattern: 'https://gitlab.com/uneeq-oss/cert-manager-mixin/-/blob/master/RUNBOOK.md#%s',
    grafanaExternalUrl: 'https://grafana-platform.gcp-rke-demo.its-software-services.com',
  },
}
EOF

docker run -v $(pwd)/${CERT_MANAGER_MIXIN}/:/data/ \
bitnami/jsonnet:latest \
-S /data/lib/alerts.jsonnet > ${CERT_MANAGER_MIXIN}.yaml

sed -i -e 's/^/  /' ${CERT_MANAGER_MIXIN}.yaml
CONTENT=$(cat ${CERT_MANAGER_MIXIN}.yaml)

cat << EOF > ${OUTPUT_FILE}
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: ${NAME}
  labels:
    app: kube-prometheus-stack
    release: kube-prometheus-stack  
spec:
${CONTENT}
EOF
