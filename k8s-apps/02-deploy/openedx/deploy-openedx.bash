#!/bin/bash
NS=openedx

echo "####"
echo "#### Deploying openedx to [${NS}] ####"

kubectl create ns ${NS}

OUTPUT_FILE=openedx-ing.yaml
sed -i "s#<<VAR_CERT_CLUSTER_DOMAIN>>#${VAR_CERT_CLUSTER_DOMAIN}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

# --------------------------
# download tutor
sudo curl -L "https://github.com/overhangio/tutor/releases/download/v12.1.2/tutor-$(uname -s)_$(uname -m)" -o /usr/local/bin/tutor
sudo chmod 0755 /usr/local/bin/tutor

PLUGIN_ROOT="$(tutor plugins printroot)"
CONFIG_ROOT="$(tutor config printroot)"

echo "This to root path configuration: ${CONFIG_ROOT}"
# --------------------------

tutor config save \
    --set ENABLE_HTTPS=true \
    --set RUN_CADDY=false \
    --set CMS_HOST=studio.${VAR_CERT_CLUSTER_DOMAIN} \
    --set LMS_HOST=${VAR_CERT_CLUSTER_DOMAIN} \
    --set CONTACT_EMAIL=dounpct@gmail.com \
    --set LANGUAGE_CODE=en \
    --set PLATFORM_NAME="MOOC-YRU"


mkdir -p "${PLUGIN_ROOT}"

cat <<MESSAGES > ${PLUGIN_ROOT}/change-pass-member.yml
name: change-pass-member
version: 0.1.0
patches:
  common-env-features: |
    "ENABLE_CHANGE_USER_PASSWORD_ADMIN" : true
MESSAGES
tutor plugins enable change-pass-member

cat <<MESSAGES > ${PLUGIN_ROOT}/cors.yml
name: change-cors
version: 0.1.0
patches:
  lms-env: |
    "CORS_ORIGIN_ALLOW_ALL" : true
MESSAGES
tutor plugins enable change-cors


cat <<MESSAGES > ${CONFIG_ROOT}/env/k8s/deployments-extend.yml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql
spec:
  resources:
    requests:
      storage: ${VAR_MYSQL_DISK_GB}
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mongodb
spec:
  resources:
    requests:
      storage: ${VAR_MONGODB_DISK_GB}
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: elasticsearch
spec:
  resources:
    requests:
      storage: ${VAR_ES_DISK_GB}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cms
spec:
  template:
    spec:
      containers:
        - name: cms
          resources:
            requests:
              memory: 2Gi
MESSAGES

cat <<MESSAGES > ${PLUGIN_ROOT}/custom-resources.yml
name: custom-resources
version: 0.1.0
patches:
  kustomization-resources: |
    patches:
      - k8s/deployments-extend.yml
MESSAGES

tutor plugins enable custom-resources

tutor config save
tutor config save --set DOCKER_IMAGE_OPENEDX=gcr.io/its-artifact-commons/yru-openedx-docker:${VAR_DOCKER_VERSION}

tutor plugins enable minio
tutor config save \
  --set OPENEDX_AWS_ACCESS_KEY=${MINIO_ACCESS_KEY} \
  --set OPENEDX_AWS_SECRET_ACCESS_KEY=${MINIO_SECRET_KEY} \
  --set MINIO_HOST=minio.${VAR_CERT_CLUSTER_DOMAIN}


tutor config save \
    --set SMTP_HOST=smtp.gmail.com \
    --set SMTP_PORT=587 \
    --set SMTP_USERNAME=${SMTP_USER} \
    --set SMTP_PASSWORD=${SMTP_PASSWORD} \
    --set SMTP_USE_TLS=true \
    --set SMTP_USE_SSL=false

# tutor k8s stop
tutor k8s quickstart

# tutor k8s createuser --staff --superuser admin dounpct@gmail.com