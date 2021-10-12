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


mkdir "$(tutor plugins printroot)"

# cat <<MESSAGES > $(tutor plugins printroot)/disable_public_account_creation.yml
# name: disablepublicaccountcreation
# version: 0.1.0
# patches:
#   common-env-features: |
#     "ALLOW_PUBLIC_ACCOUNT_CREATION" : false
# MESSAGES
# tutor plugins enable disablepublicaccountcreation

cat <<MESSAGES > $(tutor plugins printroot)/change-pass-member.yml
name: change-pass-member
version: 0.1.0
patches:
  common-env-features: |
    "ENABLE_CHANGE_USER_PASSWORD_ADMIN" : true
MESSAGES
tutor plugins enable change-pass-member

cat <<MESSAGES > $(tutor plugins printroot)/cors.yml
name: change-cors
version: 0.1.0
patches:
  lms-env: |
    "CORS_ORIGIN_ALLOW_ALL" : true
MESSAGES
tutor plugins enable change-cors


cat <<MESSAGES > $(tutor config printroot)/env/k8s/deployments-extend.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cms
spec:
  template:
    spec:
      containers:
        - resources:
            requests:
              memory: 2.5Gi
MESSAGES

cat <<MESSAGES > $(tutor plugins printroot)/custom-resources.yml
name: custom-resources
version: 0.1.0
patches:
  kustomization-resources: |
    - k8s/deployments-extend.yml
MESSAGES
tutor plugins disable custom-resources

tutor config save

tutor k8s stop
tutor k8s quickstart