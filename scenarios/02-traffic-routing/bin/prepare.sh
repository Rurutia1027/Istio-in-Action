#!/bin/bash
set -euo pipefail

# create namespace first 
kubectl apply -f ../namespace/namespace.yaml 


# then execute the Istio injection according to the target namespace 
# which lets all pods/svc/deployments created in the given namespace 
# will be injected the sidecar for future traffic fine-grained operation 
kubectl label namespace 02-traffic-routing istio-injection=enabled