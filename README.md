# Istio-in-Action

## Overview 
This project demostrates how to run Istio on a local Kubernetes cluster (Kind), how Istio perfroms sidecar injection at namespace / workload / pod levels, and how to mitigate existing microservice gateways (e.g., Spring Cloud Gateway, NGINX) into Istio to achieve unified traffic management, observability, and zero-trust security.

## Sidecar Injection Modes in Kubernetes 
### Namespace-Level Automatic Injection 
Enables injection for all pods in a namespace.

```
kubectl label namespace <ns> istio-injection=enabled
```

Characterisitics: 
- Most common mode 
- All workloads automatically receive Enovy sidecars
- Best for teams operating "service-mesh ready" namespaces

### Workload-Level Injection via Annotation 
Applied directly to Deployment/StatefulSet template: 
```yaml 
template:
  metadata:
    annotations:
      sidecar.istio.io/inject: "true"
```

Characteristics:
- Selective injection 
- Ideal for mixed environments or phased migrations


### Pod-Level Manual Injection 
Inject sidecar into a manifest before applying it:
```
istioctl kube-inject -f app.yaml | kube apply -f - 
```

Characteristics: 
- Full manual control 
- Used for debugging, demos, or environments without automatic injection

## Installing Istio + Kiali on Kind 
### Create Kind Cluster 
```
kind create cluster --name istio-name
```

### Install Istio CLI
```
curl -L https://istio.io/downloadIstio | sh -
cd istio-*/
export PATH=$PWD/bin:$PATH
```

### Install Istio (Default Profile)

### Enable Kiali 

## Integrating Existing Gateways into Istio 
### 1 Migrating NGINX Ingress to Istio Gateway 
- Disable NGINX Ingress or remove LoadBalancer entry
- Create Istio `Gateway` resource
- Create `VirtualService` to map host/path to services
- Ensure workload namespace has sidecar injection enabled 

```yaml 
apiVersion: networking.istio.io/v1alpha3
kind: Gateway 
metadata: 
  name: app-gw
spec: 
  selector: 
    istio: ingressgateway
  servers:
  - port:
      number: 80
      protocol: HTTP
    hosts:
    - "*"  
```

Migration Benefits: 
- Unified routing rules 
- Automatic mTLS
- Built-in retries, timeouts, circuit breaking
- Distributed tracing without code changes


### 2 Migrating Spring Cloud Gateway 
OptionA: Replace with Istio Gateway 
- Remove SCG routing logic
- Use Istio `Gateway + VirtualService`
- SCG becomes an ordinary microservice.

OptionB: Run SCG behind Istio 
- Keep SCG but restrict functionnalities to business-related rewrites. 
- Apply Istio mTLS + routing before SCG.
- Use Istio for telemetry and traffic control. 


Modernization Benefits: 
- Eliminates duplicated routing logic 
- Reduces custom filters 
- Enables zero-trust and consistency with other mesh services

## Directory Structure 
```
istio-in-action/
├── cluster/
│   └── kind-config.yaml
├── istio/
│   ├── gateway.yaml
│   ├── virtualservice.yaml
│   ├── kiali/
│   └── scripts/
│       └── install-istio.sh
└── microservices/
    ├── spring-cloud-gateway/
    └── nginx-gateway/
```