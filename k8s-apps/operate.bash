#!/bin/bash

#usage : operate.bash <development|production> <setup|deploy> [<component>]
cp secrets-*.txt secrets.txt
perl -pi -e 's/\r\n/\n/g' secrets.txt

export KUBECONFIG=$(pwd)/kubeconfig
export BASE_PATH=$(pwd)

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

ENV=${ENVIRONMENT} #defined in .bashrc
ACTION=$2
COMPONENT=$3

if [ -z "$COMPONENT" ]; then
    COMPONENT='all'
fi

export ROOT_PATH=$(pwd); . ./98-utils/load-env.bash ${ENV}

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

    if [[ $COMPONENT =~ ^(external-secrets|all)$ ]]; 
    then
        cd 02-deploy/external-secrets; ./deploy-external-secrets.bash; cd ${CWD}
    fi

    if [[ $COMPONENT =~ ^(prometheus|all)$ ]]; 
    then
        cd 02-deploy/prometheus; ./deploy-prometheus-config.bash; cd ${CWD}
    fi

    if [[ $COMPONENT =~ ^(loki-log|all)$ ]]; 
    then
        cd 02-deploy/loki-log; ./deploy-loki-log.bash; cd ${CWD}
    fi

    if [[ $COMPONENT =~ ^(openedx|all)$ ]];
    then
        cd 02-deploy/openedx; ./deploy-openedx.bash; cd ${CWD}
    fi
    
    if [[ $COMPONENT =~ ^(velero|all)$ ]];
    then
        cd 02-deploy/velero; ./deploy-velero.bash; cd ${CWD}
    fi

    # Put this to very last
    if [[ $COMPONENT =~ ^(certificates|all)$ ]]; 
    then
        cd 02-deploy/certificates; ./deploy-certificates.bash; cd ${CWD}
    fi    
fi