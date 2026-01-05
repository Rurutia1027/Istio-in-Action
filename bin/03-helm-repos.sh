#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/00-env.sh"

log "Adding Helm repositories"

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
# helm repo add loki https://grafana.github.io/helm-charts
# helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo add kiali https://kiali.org/helm-charts
helm repo add istio https://istio-release.storage.googleapis.com/charts
# helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

helm repo update
