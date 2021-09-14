#!/bin/bash

VERSION=v0.0.8

VAULT_FILE=gs://<change-me-here>/nonprod/secrets-nonprod.txt

sudo docker run \
-v $(pwd)/rke-addons:/wip/output \
-v ${HOME}/.config/gcloud:/root/.config/gcloud \
-e IASC_VCS_MODE=git \
-e IASC_VCS_URL='https://github.com/its-software-services-customers/yru-openedx-addons.git' \
-e IASC_VCS_REF=development \
-e IASC_VCS_FOLDER=k8s-apps \
-e IASC_VAULT_SECRETS=${VAULT_FILE} \
-it gcr.io/its-artifact-commons/iasc:${VERSION} \
init

sudo chown -R yruadmin:yruadmin rke-cluster
