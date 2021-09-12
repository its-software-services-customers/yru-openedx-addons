#!/bin/bash

USER=its

echo "${PASSWORD}" | sudo -S ls -lrt

sudo apt-get update

sudo useradd ${USER}
sudo usermod -aG wheel ${USER}

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
