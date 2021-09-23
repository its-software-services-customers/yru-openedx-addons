#!/bin/bash

NS1=minio-openedx

MINIO_SECRET=minio-secret.yaml
CONSOLE_SECRET=console-secret.yaml

echo ""
echo "### Deploying MinIO tenants to [${NS1}] ###"

kubectl create ns ${NS1}

# Dot script to preserve ENV
. ./export-secrets.bash ${BASE_PATH}/secrets.txt

### Creaet MinIO used secrets ###

cat << EOF > ${MINIO_SECRET}
---
## Secret to be used as MinIO Root Credentials
apiVersion: v1
kind: Secret
metadata:
  name: minio-creds-secret
type: Opaque
data:
  accesskey: $(echo -n ${MINIO_ACCESS_KEY} | base64)
  secretkey: $(echo -n ${MINIO_SECRET_KEY} | base64)
  MINIO_IDENTITY_OPENID_CLIENT_ID: $(echo -n ${OKTA_CLIENT_ID} | base64)
  MINIO_IDENTITY_OPENID_CLIENT_SECRET: $(echo -n ${OKTA_CLIENT_SECRET} | base64)
EOF

cat << EOF > ${CONSOLE_SECRET}
---
## Secret to be used for MinIO Console
apiVersion: v1
kind: Secret
metadata:
  name: console-secret
type: Opaque
data:
  CONSOLE_PBKDF_PASSPHRASE: $(echo -n ${CONSOLE_PBKDF_PASSPHRASE} | base64)
  CONSOLE_PBKDF_SALT: $(echo -n ${CONSOLE_PBKDF_SALT} | base64)
  CONSOLE_ACCESS_KEY: $(echo -n ${CONSOLE_ACCESS_KEY} | base64)
  CONSOLE_SECRET_KEY: $(echo -n ${CONSOLE_SECRET_KEY} | base64)
EOF

kubectl apply -f ${MINIO_SECRET} -n ${NS1}
kubectl apply -f ${CONSOLE_SECRET} -n ${NS1}

OUTPUT_FILE=tenant.yaml
sed -i "s#<<VAR_CERT_CLUSTER_DOMAIN>>#${VAR_CERT_CLUSTER_DOMAIN}#g" ${OUTPUT_FILE}
sed -i "s#<<VAR_MIN_POOL1_DISK_GB>>#${VAR_MIN_POOL1_DISK_GB}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS1}

OUTPUT_FILE=minio-openedx-ing.yaml
sed -i "s#<<VAR_CERT_CLUSTER_DOMAIN>>#${VAR_CERT_CLUSTER_DOMAIN}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS1}
