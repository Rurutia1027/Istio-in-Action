#!/usr/bin/env bash
set -euo pipefail

GATEWAY_API_VERSION="v1.1.0"

echo "Installing Gateway API CRDs (version: ${GATEWAY_API_VERSION})..."

kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/${GATEWAY_API_VERSION}/standard-install.yaml

echo "Gateway API CRDs installation triggered."
