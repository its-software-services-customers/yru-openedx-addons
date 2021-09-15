#!/bin/bash

kubectl create ns cert-manager
kubectl apply -f rendered-cert-manager.yaml
