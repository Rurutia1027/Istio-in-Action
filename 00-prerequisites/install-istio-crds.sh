#!/usr/bin/env bash

set -euo pipefail

ISTIO_VERSION="${ISTIO_VERSION:-1.28.2}"

echo "Installing Istio CRDs (version: ${ISTIO_VERSION})"

istioctl install \
  --set profile=minimal \
  --set components.pilot.enabled=false \
  --skip-confirmation 


echo "Istio CRDs Installation Finished."