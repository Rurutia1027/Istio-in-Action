#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

bash "$DIR/01-kind-cluster.sh"
bash "$DIR/02-namespaces.sh"
bash "$DIR/03-helm-repos.sh"

bash "$DIR/10-observability.sh"
bash "$DIR/20-istio.sh"
bash "$DIR/30-tracing.sh"
bash "$DIR/40-kiali.sh"

bash "$DIR/90-rancher.sh"

kubectl wait --for=condition=Ready pods --all -n istio-system --timeout=300s
kubectl wait --for=condition=Ready pods --all -n cattle-system --timeout=300s

echo "====================================================="
echo "Setup complete"
echo "====================================================="
