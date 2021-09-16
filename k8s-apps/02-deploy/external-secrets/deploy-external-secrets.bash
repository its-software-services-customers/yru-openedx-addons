#!/bin/bash

NS=external-secrets
VERSION=${VAR_EXT_SECRET_VERSION} #Need to match Helm chart version
SA=${VAR_EXT_SECRET_SA}
KEY_FILE=sm.json
SECRET=gcp-secret-manager

echo "####"
echo "#### Deploying external-secret to [${NS}] ####"

# !!! Need to manually install the CRD here
URL=https://raw.githubusercontent.com/external-secrets/kubernetes-external-secrets/${VERSION}/charts/kubernetes-external-secrets/crds/kubernetes-client.io_externalsecrets_crd.yaml

kubectl create ns ${NS}
kubectl apply -f rendered-external-secrets.yaml -n ${NS}
kubectl apply -f ${URL} -n ${NS}


if [ -f "${KEY_FILE}" ]; then
    echo "File ${KEY_FILE} already exists. So, do nothing!!!"
else 
    gcloud iam service-accounts keys create ${KEY_FILE} --iam-account=${SA} --project=${VAR_EXT_SECRET_PROJECT}
fi

kubectl delete secret ${SECRET} -n ${NS}

kubectl create secret generic ${SECRET} \
--from-file=gcp-creds.json=${KEY_FILE} \
-n ${NS}
