#!/bin/bash
set -euo pipefail

# -----------------------------
# Config
# -----------------------------
CLUSTER_NAME="istio-demo"
K8S_CONFIG_FILE="config/kind-config.yaml"
METRICS_NAMESPACE="metrics"
ISTIO_NAMESPACE="istio-system"

PROM_URL="http://prometheus-server.${METRICS_NAMESPACE}.svc.cluster.local"
JAEGER_URL="http://jaeger-query.${METRICS_NAMESPACE}.svc.cluster.local"

# Helm values paths
PROM_VALUES="helm/prometheus-values.yaml"
GRAFANA_VALUES="helm/grafana-values.yaml"

# -----------------------------
# Create Kind Cluster
# -----------------------------
echo "====================================================="
echo "[1] Creating Kind cluster"
echo "====================================================="
if ! kind get clusters | grep -q "$CLUSTER_NAME"; then
    kind create cluster --name "$CLUSTER_NAME" --config "$K8S_CONFIG_FILE"
else
    echo "[INFO] Kind cluster '$CLUSTER_NAME' already exists. Skipping creation."
fi

kubectl wait --for=condition=Ready nodes --all --timeout=180s
kubectl get nodes -o wide
kubectl get pods -A

# -----------------------------
# Namespaces
# -----------------------------
kubectl create namespace "$METRICS_NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace "$ISTIO_NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

# -----------------------------
# Helm Repos
# -----------------------------
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add loki https://grafana.github.io/helm-charts
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo add kiali https://kiali.org/helm-charts
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

# -----------------------------
# Install Prometheus + Grafana + Loki
# -----------------------------
helm upgrade --install prometheus prometheus-community/prometheus \
  -n "$METRICS_NAMESPACE" \
  -f "$PROM_VALUES"

helm upgrade --install grafana grafana/grafana \
  -n "$METRICS_NAMESPACE" \
  -f "$GRAFANA_VALUES"

helm upgrade --install loki grafana/loki-stack -n "$METRICS_NAMESPACE"

# -----------------------------
# Install Istio Core
# -----------------------------
helm install istio-base istio/base -n "$ISTIO_NAMESPACE"
helm install istiod istio/istiod -n "$ISTIO_NAMESPACE" --set telemetry.enabled=true
helm install istio-ingress istio/gateway -n "$ISTIO_NAMESPACE"

# -----------------------------
# Install Jaeger
# -----------------------------
helm install jaeger jaegertracing/jaeger \
  -n "$METRICS_NAMESPACE" \
  --set provisionDataStore.cassandra=false \
  --set storage.type=memory

# -----------------------------
# Install Kiali
# -----------------------------
helm install kiali-server kiali/kiali-server \
  -n "$ISTIO_NAMESPACE" \
  --set auth.strategy=anonymous \
  --set external_services.prometheus.url="$PROM_URL" \
  --set external_services.tracing.enabled=true \
  --set external_services.tracing.provider=jaeger \
  --set external_services.tracing.url="$JAEGER_URL"




# -----------------------------
# Wait for all pods
# -----------------------------
kubectl wait --for=condition=Ready pods --all -n "$METRICS_NAMESPACE" --timeout=300s
kubectl wait --for=condition=Ready pods --all -n "$ISTIO_NAMESPACE" --timeout=300s

# -----------------------------
# Summary & Port-forward tips
# -----------------------------
echo "====================================================="
echo "[INFO] Setup complete!"
echo "[INFO] Prometheus: kubectl port-forward -n $METRICS_NAMESPACE svc/prometheus 9090:9090"
echo "[INFO] Grafana: kubectl port-forward -n $METRICS_NAMESPACE svc/grafana 3000:3000"
echo "[INFO] Jaeger: kubectl port-forward -n $METRICS_NAMESPACE svc/jaeger-query 16686:16686"
echo "[INFO] Kiali: kubectl port-forward -n $ISTIO_NAMESPACE svc/kiali 20001:20001"
echo "====================================================="
