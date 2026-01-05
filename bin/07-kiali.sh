#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/00-env.sh"

log "Installing Kiali"
helm upgrade --install kiali-server kiali/kiali-server \
  -n "$ISTIO_NAMESPACE" \
  --set auth.strategy=anonymous \
  --set external_services.prometheus.url="$PROM_URL" \
  --set external_services.tracing.enabled=true \
  --set external_services.grafana.url="$GRAFANA_URL"
  # --set external_services.tracing.provider=jaeger \
  # --set external_services.tracing.url="$JAEGER_URL" \
