#!/usr/bin/bash

# --- original ---
tutor config save \
    --set MINIO_GATEWAY=null \
    --set OPENEDX_AWS_ACCESS_KEY=openedx \
    --set OPENEDX_AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXX \
    --set MINIO_BUCKET=openedx \
    --set MINIO_FILE_UPLOAD_BUCKET_NAME=openedxuploads \
    --set MINIO_HOST=minio.$(tutor config printvalue LMS_HOST) \
    --set MINIO_ROOT_USER=minioadmin \
    --set MINIO_ROOT_PASSWORD=minioadmin \
    --set MINIO_ACCESS_KEY=minioadmin \
    --set MINIO_SECRET_KEY=minioadmin

tutor k8s quickstart