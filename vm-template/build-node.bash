#!/bin/bash

set -o allexport; source .env; set +o allexport

cd rke-cluster
packer build -force rke-node-vsphere.json
