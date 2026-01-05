#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/00-env.sh"

log "Creating namespaces"

for ns in "$ISTIO_NAMESPACE" "$RANCHER_NAMESPACE"; do
  kubectl create namespace "$ns" --dry-run=client -o yaml | kubectl apply -f -
done

kubectl label namespace "$RANCHER_NAMESPACE" \
  pod-security.kubernetes.io/enforce=baseline --overwrite