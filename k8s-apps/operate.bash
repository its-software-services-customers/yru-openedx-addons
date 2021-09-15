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

if [ -z "${KUBECONFIG}" ]; then
    echo "Need environment variable KUBECONFIG to be populated first!!!"
    exit 1
fi

ENV=$1
ACTION=$2
COMPONENT=$3

if [ -z "$COMPONENT" ]; then
    COMPONENT='all'
fi

export ROOT_PATH=$(pwd); . ./98-utils/load-env.bash ${ENV}

echo "Debug=[${TEST_ENV}]"
kubectl get nodes

CWD=$(pwd)

if [ "$ACTION" = 'setup' ]; then
    if [[ $COMPONENT =~ ^(prometheus|all)$ ]]; 
    then
        cd 01-setup/prometheus; ./setup-prometheus.bash; cd ${CWD}
    fi

    if [[ $COMPONENT =~ ^(storage|all)$ ]]; 
    then
        cd 01-setup/storage; ./setup-storage.bash; cd ${CWD}
    fi

    if [[ $COMPONENT =~ ^(cert-manager|all)$ ]]; 
    then
        cd 01-setup/cert-manager; ./setup-cert-manager.bash; cd ${CWD}
    fi    
fi

if [ "$ACTION" = 'deploy' ]; then
    if [[ $COMPONENT =~ ^(nginx-svc|all)$ ]]; 
    then
        cd 02-deploy/nginx-svc; ./deploy-nginx-svc.bash; cd ${CWD}
    fi
fi