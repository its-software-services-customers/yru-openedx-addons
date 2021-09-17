#!/bin/bash

OUTPUT_FILE=$1

if [ -z "${OUTPUT_FILE}" ]
then
  OUTPUT_FILE=generated-alertmanager-config.yaml
fi

cp alertmanager-config-tpl.yaml ${OUTPUT_FILE}

URL_KEY=$(echo -n ${ALERT_NOTI_SLACK_URL})
sed -i "s#__SLACK_URL__#${URL_KEY}#g" ${OUTPUT_FILE}

CFG_FILE=$(cat ${OUTPUT_FILE} | base64 -w0)

cat << EOF > ${OUTPUT_FILE}
apiVersion: v1
kind: Secret
metadata:
  name: alertmanager-kube-prometheus-stack-alertmanager
  labels:
    app: kube-prometheus-stack-alertmanager
    release: "kube-prometheus-stack"  
data:
  alertmanager.yaml: ${CFG_FILE}
EOF
