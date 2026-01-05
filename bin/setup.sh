#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

bash "$DIR/01-k8s-cluster.sh"
bash "$DIR/02-namespaces.sh"
bash "$DIR/03-helm-repos.sh"

bash "$DIR/04-observability.sh"
bash "$DIR/05-istio.sh"
# bash "$DIR/06-tracing.sh"
bash "$DIR/07-kiali.sh"
# bash "$DIR/08-rancher.sh"

kubectl wait --for=condition=Ready pods --all -n istio-system --timeout=300s
kubectl wait --for=condition=Ready pods --all -n cattle-system --timeout=300s

echo "====================================================="
echo "Setup complete"
echo "====================================================="
