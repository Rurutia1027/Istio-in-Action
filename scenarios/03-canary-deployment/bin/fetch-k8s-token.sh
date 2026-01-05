#!/bin/bash
set -euo pipefail

NAMESPACE="03-canary-deployment"
SA_NAME="bdd-test-account"

# fetch token 
SECRET_NAME=$(kubectl get sa $SA_NAME -n $NAMESPACE -o jsonpath="{.secrets[0].name}")
TOKEN=$(kubectl get secret $SECRET_NAME -n $NAMESPACE -o jsonpath="{.data.token}" | base64 --decode)

# fetch  API Server address 
K8S_API_SERVER=$(kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[0].cluster.server}')

# export to environment for TypeScript
export K8S_TOKEN="$TOKEN"
export K8S_API_SERVER="$K8S_API_SERVER"