#!/bin/bash

ALIAS1=yru-openedx
ALIAS1_URL=https://minio-syslog.${VAR_CERT_CLUSTER_DOMAIN}

# Dot script to preserve ENV
. ./export-secrets.bash ${BASE_PATH}/secrets.txt

# Install MinIO client
echo ""
echo "### Downloading MinIO client"
sudo curl -LO https://dl.min.io/client/mc/release/linux-amd64/mc
sudo chmod +x mc
#sudo chown ${USER}:wheel mc

# Setting MinIO client alias
echo ""
echo "### Setting MinIO client alias(es)"
./mc alias --insecure set ${ALIAS1} ${ALIAS1_URL} ${MINIO_ACCESS_KEY} ${MINIO_SECRET_KEY}

# Creating bucket
echo ""
echo "### Creating bucket(s)"
./mc mb --insecure ${ALIAS1}/yru-openedx