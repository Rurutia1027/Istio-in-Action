#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/00-env.sh"

log "Creating kind cluster: ${CLUSTER_NAME}"

if ! kind get clusters | grep -q "$CLUSTER_NAME"; then
  kind create cluster \
    --name "$CLUSTER_NAME" \
    --config "$K8S_CONFIG_FILE"
else
  log "Kind cluster already exists"
fi

kubectl wait --for=condition=Ready nodes --all --timeout=180s
kubectl get nodes -o wide