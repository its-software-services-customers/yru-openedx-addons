#!/bin/bash

PATTERN1='(.+)=(.+)'
PATTERN2='(.+)=(.+)=(.+)'

FILE=$1

while read LINE;
do
    STR=''
    if [[ "${LINE}" =~ ${PATTERN2} ]]; then
        NAME=${BASH_REMATCH[1]}
        KEY=${BASH_REMATCH[2]}
        VALUE=${BASH_REMATCH[3]}

        STR="${NAME}=\"${KEY}=${VALUE}\""
        eval "export ${STR}"
    else
        if [[ "${LINE}" =~ ${PATTERN1} ]]; then
            NAME=${BASH_REMATCH[1]}
            VALUE=${BASH_REMATCH[2]}

            STR="${NAME}=\"${VALUE}\""
            eval "export ${STR}"
        fi
    fi
done <${FILE}