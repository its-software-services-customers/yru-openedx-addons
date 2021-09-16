#!/bin/bash

NS=cert-manager
SECRET=gcp-cloud-dns-account-key
KEY_FILE=cloud-dns-rke-demo.json
SA=${VAR_CERT_CLOUD_DNS_SA}

echo "####"
echo "#### Deploying certificates to [${NS}] ####"

if [ -f "${KEY_FILE}" ]; then
    echo "File ${KEY_FILE} already exists. So, do nothing!!!"
else 
    gcloud iam service-accounts keys create ${KEY_FILE} --iam-account=${SA} --project=${VAR_CERT_CLOUD_DNS_PROJECT}
fi

kubectl delete secret ${SECRET} -n ${NS}

kubectl create secret generic ${SECRET} \
--from-file=service-account.json=${KEY_FILE} \
-n ${NS}

OUTPUT_FILE=rendered-cluster-certs.yaml
sed -i "s#<<VAR_CERT_CLUSTER_DOMAIN>>#${VAR_CERT_CLUSTER_DOMAIN}#g" ${OUTPUT_FILE}
sed -i "s#<<VAR_CERT_LETENCRYPT_ENV>>#${VAR_CERT_LETENCRYPT_ENV}#g" ${OUTPUT_FILE}
sed -i "s#<<VAR_CERT_SA_PROJECT>>#${VAR_CERT_SA_PROJECT}#g" ${OUTPUT_FILE}
sed -i "s#<<VAR_CERT_LETENCRYPT_EMAIL>>#${VAR_CERT_LETENCRYPT_EMAIL}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE}
