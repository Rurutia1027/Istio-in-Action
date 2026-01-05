#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/00-env.sh"

log "Installing Istio base"
helm upgrade --install istio-base istio/base \
  -n "$ISTIO_NAMESPACE" --create-namespace

log "Installing Istiod"
helm upgrade --install istiod istio/istiod \
  -n "$ISTIO_NAMESPACE" \
  --set telemetry.enabled=true

log "Installing Istio ingress gateway"
helm upgrade --install istio-ingress istio/gateway \
  -n "$ISTIO_NAMESPACE"