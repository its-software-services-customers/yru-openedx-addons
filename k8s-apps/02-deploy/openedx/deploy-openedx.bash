#!/usr/bin/bash

# --------------------------
# download tutor
sudo curl -L "https://github.com/overhangio/tutor/releases/download/v12.1.2/tutor-$(uname -s)_$(uname -m)" -o /usr/local/bin/tutor
sudo chmod 0755 /usr/local/bin/tutor
echo "This to root path configuration: $(tutor config printroot)"
# --------------------------

# --------------------------
# start clear root path configuration"
# sudo rm -rf $(tutor config printroot)
# --------------------------

# --------------------------
# install tutor
# tutor k8s quickstart

tutor config save \
    --set ENABLE_HTTPS=false \
    --set CMS_HOST=studio.openedx.yru-oedx-t.its-software-services.com \
    --set LMS_HOST=openedx.yru-oedx-t.its-software-services.com \
    --set CONTACT_EMAIL=dounpct@gmail.com \
    --set LANGUAGE_CODE=en \
    --set PLATFORM_NAME=first-edx

# tutor k8s quickstart
tutor k8s start
tutor k8s init

# echo "root path configuration"
# 
# ls "$(tutor config printroot)"
# cat "$(tutor config printroot)/config.yaml"
# echo "you can access from"
# echo "LMS : k8s.overhang.io"
# echo "LMS : studio.k8s.overhang.io"
# --------------------------

# --------------------------
# this is for export external load balance for minikube 
# left for production
# sudo minikube tunnel 
# --------------------------

# install minio plugin
# tutor plugins enable minio
# tutor config save

# tutor k8s quickstart

# tutor k8s start
# tutor k8s init