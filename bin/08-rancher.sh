#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/00-env.sh"

log "Installing cert-manager (Rancher dependency)"
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml

log "Installing Rancher"
helm upgrade --install rancher rancher-latest/rancher \
  -n "$RANCHER_NAMESPACE" \
  --set hostname=rancher.localhost \
  --set replicas=1 \
  --set bootstrapPassword=admin \
  --set ingress.tls.source=secret