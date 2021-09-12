#!/bin/bash

TIMESTAMP=$(date "+%Y%m%d-%T")
echo "${TIMESTAMP}" > "last-build-on-${TIMESTAMP}.txt"
ls -lrt

USER=${ADMIN}

echo "${PASSWORD}" | sudo -S ls -lrt

sudo apt-get update

sudo groupadd docker
sudo usermod -aG docker ${USER}

sudo snap install docker
sudo apt install unzip

# terraform
TERRAFORM_VERSION=1.0.3
TERRAFORM_URL=https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
curl -LO "${TERRAFORM_URL}"
unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
chmod 555 terraform
sudo mv ./terraform /usr/local/bin/terraform

# kubectl
KUBECTL_VERSION=v1.19.0
KUBECTL_URL=https://storage.googleapis.com/kubernetes-release/release
curl -LO "${KUBECTL_URL}/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod 555 kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# GCloud
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get -y install apt-transport-https ca-certificates gnupg
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get -y update && sudo apt-get -y install google-cloud-sdk
gcloud version
