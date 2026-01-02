#!/usr/bin/env bash
set -euo pipefail

echo "Validating Istio CRDs..."

REQUIRED_CRDS=(
    virtualservices.networking.istio.io
    destinationrules.networking.istio.io
    gateways.networking.istio.io
    serviceentries.networking.istio.io
    peerauthentications.security.istio.io
    authorizationpolicies.security.istio.io
)

for crd in "${REQUIRED_CRDS[@]}"; do 
  kubectl get crd "${crd}" > /dev/null 2>&1 \
      && echo "✔ ${crd} exists" \
    || { echo "✖ ${crd} missing"; exit 1; }
done 

echo "All Istio CRDs validated successfully"