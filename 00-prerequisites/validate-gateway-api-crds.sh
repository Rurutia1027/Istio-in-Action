#!/usr/bin/env bash
set -euo pipefail

echo "Validating Gateway API CRDs..."

REQUIRED_CRDS=(
  gateways.gateway.networking.k8s.io
  httproutes.gateway.networking.k8s.io
  referencegrants.gateway.networking.k8s.io
)

for crd in "${REQUIRED_CRDS[@]}"; do
  kubectl get crd "${crd}" >/dev/null 2>&1 \
    && echo "✔ ${crd} exists" \
    || { echo "✖ ${crd} missing"; exit 1; }
done

echo "All Gateway API CRDs validated successfully."
