#!/bin/bash
set -e

# --- Config ---
CLUSTER_NAME="istio-demo"
ISTIO_NAMESPACE="istio-system"
PROM_URL="http://prometheus-server.${ISTIO_NAMESPACE}:80"
KIALI_POD_NAME="kiali-server"

# --- Delete old cluster ---
echo "Deleting old Kind cluster (if exists)..."
kind delete cluster --name $CLUSTER_NAME || true

# --- Create new Kind cluster ---
echo "Creating new Kind cluster..."
kind create cluster --name $CLUSTER_NAME
kubectl cluster-info --context kind-$CLUSTER_NAME

# --- Install Helm if missing ---
if ! command -v helm &> /dev/null; then
    echo "Installing Helm..."
    brew install helm
fi

helm version

# --- Add Helm repos ---
echo "Adding Helm repos..."
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo add kiali https://kiali.org/helm-charts
helm repo update

# --- Create Istio namespace ---
kubectl create namespace $ISTIO_NAMESPACE || true

# --- Install Istio core components ---
echo "Installing Istio base..."
helm install istio-base istio/base -n $ISTIO_NAMESPACE

echo "Installing Istio discovery (istiod)..."
helm install istiod istio/istiod -n $ISTIO_NAMESPACE

echo "Installing Istio ingress gateway..."
helm install istio-ingress istio/gateway -n $ISTIO_NAMESPACE

# --- Install Istio telemetry stack (Prometheus + Grafana) ---
echo "Installing Istio telemetry stack..."
helm install istio-monitoring istio/istio-telemetry -n $ISTIO_NAMESPACE

# --- Install Kiali ---
echo "Installing Kiali..."
helm install kiali-server kiali/kiali-server \
  -n $ISTIO_NAMESPACE \
  --set auth.strategy=anonymous \
  --set external_services.prometheus.url=$PROM_URL

# --- Wait for Pods to be running ---
echo "Waiting for all Istio pods to be running..."
kubectl wait --for=condition=Ready pods --all -n $ISTIO_NAMESPACE --timeout=300s

# --- Port-forward Kiali and Grafana ---
echo "Port-forwarding Kiali (20001) and Grafana (3000)..."
kubectl -n $ISTIO_NAMESPACE port-forward svc/kiali 20001:20001 &
kubectl -n $ISTIO_NAMESPACE port-forward svc/grafana 3000:80 &

echo "Setup complete!"
echo "Kiali: http://localhost:20001  |  Grafana: http://localhost:3000"
echo "Prometheus URL for Kiali: $PROM_URL"
