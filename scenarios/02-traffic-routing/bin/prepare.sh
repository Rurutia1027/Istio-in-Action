#!/bin/bash
set -euo pipefail

kubectl apply -f ../namespace/namespace.yaml 

kubectl label namespace 02-traffic-routing istio-injection=enabled