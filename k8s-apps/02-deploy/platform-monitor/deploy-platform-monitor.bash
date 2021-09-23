#!/bin/bash

NS=platform-monitor

echo "####"
echo "#### Deploying platform monitoring to [${NS}] ####"

kubectl create ns ${NS}
kubectl apply -f rendered-prometheus-stack.yaml -n ${NS}


OUTPUT_FILE=google-oidc-secret.yaml
sed -i "s#<<VAR_PROMETHEUS_SECRET_PROJECT>>#${VAR_PROMETHEUS_SECRET_PROJECT}#g" ${OUTPUT_FILE}
sed -i "s#<<VAR_PROMETHEUS_SECRET_NAME>>#${VAR_PROMETHEUS_SECRET_NAME}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

#Use this for debug only
OUTPUT_FILE=prometheus-ing.yaml
sed -i "s#<<VAR_CERT_CLUSTER_DOMAIN>>#${VAR_CERT_CLUSTER_DOMAIN}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

# Grafana here
OUTPUT_FILE=grafana-platform-ing.yaml
sed -i "s#<<VAR_CERT_CLUSTER_DOMAIN>>#${VAR_CERT_CLUSTER_DOMAIN}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

OUTPUT_FILE=rendered-grafana-platform.yaml
sed -i "s#<<VAR_CERT_CLUSTER_DOMAIN>>#${VAR_CERT_CLUSTER_DOMAIN}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

CURRENT_DIR=$(pwd)

#=== Cert Manager ===
DIR_NAME=cert-manager
kubectl apply -f ${DIR_NAME}/certmanager-service-monitor.yaml -n ${NS}

CERTMANAGER_RULES=generated-certmanager-rules.yaml
cd ${DIR_NAME}; ./generate-alert-rules-certmanager.bash ${CERTMANAGER_RULES}
kubectl apply -f ${CERTMANAGER_RULES} -n ${NS}
cd ${CURRENT_DIR}
#===

#=== Prometheus ===
DIR_NAME=prometheus
PROMETHEUS_RULES=generated-prometheus-rules.yaml
cd ${DIR_NAME}; ./generate-alert-rules-prometheus.bash ${PROMETHEUS_RULES}
kubectl apply -f ${PROMETHEUS_RULES} -n ${NS}
cd ${CURRENT_DIR}

ALERTMANAGER_RULES=generated-alertmanager-rules.yaml
cd ${DIR_NAME}; ./generate-alert-rules-alertmanager.bash ${ALERTMANAGER_RULES}
kubectl apply -f ${ALERTMANAGER_RULES} -n ${NS}
cd ${CURRENT_DIR}

ALERTMANAGER_CONFIG=generated-alertmanager-config.yaml
cd ${DIR_NAME}; ./generate-alertmanager-config.bash ${ALERTMANAGER_CONFIG}
kubectl apply -f ${ALERTMANAGER_CONFIG} -n ${NS}
cd ${CURRENT_DIR}
#===