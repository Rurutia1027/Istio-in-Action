#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/00-env.sh"

log "Installing Jaeger"
helm upgrade --install jaeger jaegertracing/jaeger \
  -n "$ISTIO_NAMESPACE" \
  --set provisionDataStore.cassandra=false \
  --set storage.type=memory