#!/bin/bash 

set -e 

# Namespace for Bookinfo 
BOOKINFO_NS="bookinfo"

echo "=== Creating namespace ${BOOKINFO_NS} ==="
kubectl create namespace ${BOOKINFO_NS} --dry-run=client -o yaml | kubectl apply -f -

echo "=== Deploying Bookinfo source manifests ==="
kubectl apply -n $BOOKINFO_NS -f bookinfo/src/

echo "=== Deploying networking / routing rules ==="
kubectl apply -n $BOOKINFO_NS -f bookinfo/networking/