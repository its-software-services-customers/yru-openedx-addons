#!/usr/bin/bash

echo "MINIO_GATEWAY                 : " $(tutor config printvalue MINIO_GATEWAY)
echo "OPENEDX_AWS_ACCESS_KEY        : " $(tutor config printvalue OPENEDX_AWS_ACCESS_KEY)
echo "OPENEDX_AWS_SECRET_ACCESS_KEY : " $(tutor config printvalue OPENEDX_AWS_SECRET_ACCESS_KEY)

echo "MINIO_BUCKET_NAME             : " $(tutor config printvalue MINIO_BUCKET_NAME)
echo "MINIO_FILE_UPLOAD_BUCKET_NAME : " $(tutor config printvalue MINIO_FILE_UPLOAD_BUCKET_NAME)

echo "MINIO_HOST                    : " $(tutor config printvalue MINIO_HOST)
echo "MINIO_DOCKER_IMAGE            : " $(tutor config printvalue MINIO_DOCKER_IMAGE)
echo "MINIO_MC_DOCKER_IMAGE         : " $(tutor config printvalue MINIO_MC_DOCKER_IMAGE)

echo "MINIO_ROOT_USER               : " $(tutor config printvalue MINIO_ROOT_USER)
echo "MINIO_ROOT_PASSWORD           : " $(tutor config printvalue MINIO_ROOT_PASSWORD)

echo "MINIO_ACCESS_KEY              : " $(tutor config printvalue MINIO_ACCESS_KEY)
echo "MINIO_SECRET_KEY              : " $(tutor config printvalue MINIO_SECRET_KEY)
