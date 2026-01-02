#!/usr/bin/env bash

set -euo pipefail

ISTIO_VERSION="1.28.2"
ISTIO_REPO="https://raw.githubusercontent.com/istio/istio/${ISTIO_VERSION}" 

echo "Installing Istio CRDs (version: ${ISTIO_VERSION})"

echo "Applying base CRDs..."
kubectl apply -f "${ISTIO_REPO}/manifests/charts/base/crds"

echo "Waiting for CRDs to be established ..."
kubectl wait --for=condition=Established crd \
  virtualservices.networking.istio.io \
  destinationrules.networking.istio.io \
  gateways.networking.istio.io \
  serviceentries.networking.istio.io \
  envoyfilters.networking.istio.io \
  sidecars.networking.istio.io \
  peerauthenticaitons.security.istio.io \
  requestauthentications.security.istio.io \
  authorizationpolicies.security.isio.io \
  --timeout=120s

echo "Istio CRDs installed successfully."