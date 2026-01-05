#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/00-env.sh"


log "Installing Prometheus"
helm upgrade --install prometheus prometheus-community/prometheus \
  -n "$ISTIO_NAMESPACE" \
  -f "$PROM_VALUES"


log "Installing Grafana"
helm upgrade --install grafana grafana/grafana \
  -n "$ISTIO_NAMESPACE" \
  -f "$GRAFANA_VALUES"

log "Installing Loki"
helm upgrade --install loki grafana/loki-stack \
  -n "$ISTIO_NAMESPACE"  
