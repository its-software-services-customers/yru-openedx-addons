#!/bin/bash
NS=openedx

echo "####"
echo "#### Deploying openedx to [${NS}] ####"

kubectl create ns ${NS}

OUTPUT_FILE=openedx-ing.yaml
sed -i "s#<<VAR_CERT_CLUSTER_DOMAIN>>#${VAR_CERT_CLUSTER_DOMAIN}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

# --------------------------
# download tutor
sudo curl -L "https://github.com/overhangio/tutor/releases/download/v12.1.2/tutor-$(uname -s)_$(uname -m)" -o /usr/local/bin/tutor
sudo chmod 0755 /usr/local/bin/tutor
echo "This to root path configuration: $(tutor config printroot)"
# --------------------------

tutor config save \
    --set ENABLE_HTTPS=false \
    --set CMS_HOST=studio.${VAR_CERT_CLUSTER_DOMAIN} \
    --set LMS_HOST=${VAR_CERT_CLUSTER_DOMAIN} \
    --set CONTACT_EMAIL=dounpct@gmail.com \
    --set LANGUAGE_CODE=th \
    --set PLATFORM_NAME=yru-mooc-oedx

tutor k8s quickstart