#!/bin/bash
set -euo pipefail

# -----------------------------
# Cluster
# -----------------------------
CLUSTER_NAME="k8s-istio-cluster"
K8S_CONFIG_FILE="config/kind-config.yaml"

# -----------------------------
# Namespaces
# -----------------------------
ISTIO_NAMESPACE="istio-system"
OBS_NAMESPACE="observability-system"
RANCHER_NAMESPACE="cattle-system"

# -----------------------------
# URLs
# -----------------------------
PROM_URL="http://prometheus-server.${ISTIO_NAMESPACE}.svc.cluster.local"
JAEGER_URL="http://jaeger-query.${ISTIO_NAMESPACE}.svc.cluster.local"
GRAFANA_URL="http://grafana.${ISTIO_NAMESPACE}.svc.cluster.local:3000"

# -----------------------------
# Helm values
# -----------------------------
PROM_VALUES="config/prometheus-values.yaml"
GRAFANA_VALUES="config/grafana-values.yaml"

log() {
  echo "[$(date +%H:%M:%S)] $*"
}