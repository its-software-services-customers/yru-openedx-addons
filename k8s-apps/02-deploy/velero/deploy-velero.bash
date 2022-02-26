#!/bin/bash

NS=velero

echo "####"
echo "#### Deploying velero to [${NS}] ####"

tempdir=$(pwd)
sudo wget https://github.com/vmware-tanzu/velero/releases/download/v1.7.1/velero-v1.7.1-linux-amd64.tar.gz
sudo tar -xvf velero-v1.7.1-linux-amd64.tar.gz
cd velero-v1.7.1-linux-amd64/
sudo mv velero /usr/local/bin
cd $tempdir

kubectl create ns ${NS}

#

OUTPUT_FILE=rendered-velero.yaml
sed -i "s#<<VAR_VELERO_BUCKRT>>#${VAR_VELERO_BUCKRT}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}
