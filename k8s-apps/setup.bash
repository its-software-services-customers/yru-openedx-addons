#!/bin/bash

if [ -z "$1" ]; then
    echo "Argument <env> is required!!!"
    exit 1
fi

${ENV}=$1
export ROOT_PATH=$(pwd)
. ./98-utils/load-env.bash ${ENV}

echo "Debug=[${TEST_ENV}]"
