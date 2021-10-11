#!/bin/bash

set -o allexport; source .env; set +o allexport

cd rke-manager
packer build -force vm-manager-vsphere-ubuntu20.json
