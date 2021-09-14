#!/bin/bash

#usage : operate.bash <development|production> <setup|deploy> [<component>]

if [ -z "$1" ]; then
    echo "Argument <env> is required!!!"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Argument <setup|deploy> is required!!!"
    exit 1
fi

ENV=$1
ACTION=$2
COMPONENT=$3

if [ -z "$COMPONENT" ]; then
    COMPONENT='all'
fi

export ROOT_PATH=$(pwd); . ./98-utils/load-env.bash ${ENV}
export KUBECONFIG=${HOME}/rke-cluster/kubeconfig;

echo "Debug=[${TEST_ENV}]"
kubectl get nodes