#!/bin/bash

if [ -z "$1" ]; then
    echo "Argument <env> is required!!!"
    exit 1
fi

${ENV}=$1
. ${ROOT_PATH}/load-env.bash ${ENV}

echo "Debug=[${TEST_ENV}]"
