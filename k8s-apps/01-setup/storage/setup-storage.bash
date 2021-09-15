
#!/bin/bash

echo ""
echo "### Setting up storage class ###"

OUTPUT_FILE=sc-default.yaml
sed -i "s#<<VAR_STORAGE_DATASTORE_STANDARD>>#${VAR_STORAGE_DATASTORE_STANDARD}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE}
