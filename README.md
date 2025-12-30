# Istio in Action | [![K8s Cluster Setup & Deploy Istio Stach CI](https://github.com/Rurutia1027/Istio-in-Action/actions/workflows/ci.yaml/badge.svg)](https://github.com/Rurutia1027/Istio-in-Action/actions/workflows/ci.yaml)

## Overview 
This repository demostrates **production-oriented Istio usage patterns** on Kubernetes, starting from official Istio examples (BookInfo) and evolving toward **enterprise-grade traffic management**, **security**, **observability**, **automation**, and **GitOps**.

The goal is not to showcase isolated features, but to model how Istio is introduced, validated, automated, and operated in real-world systems. 

Key principles of this repository: 
- Scenarios over demos: each feature is treated as a verifiable, repeatable scenario.
- Progressive complexity: from manual validation to automated and GitOps-driven workflows. 
- Production realism: configurations align with patterns used in real clusters, not toy examples. 



## Repository Goals
- Provide a structured learning and reference path for Istio 
- Demostrate advance Istio traffic, security, and deployment strategies
- Show how Istio integrates with GitOps tooling (Argo CD)
- Serve as a reusable reference for interviews, blogs, and internal enableent


## High-Level Architecture 
- Kubernetes: Kind (local, reproducible clusters)
- Service Mesh: Istio 
- Sample Application: Bookinfo (baseline), extensible to real microservices
- GitOps: Argo CD
- Automation: Istio-aware traffic and security assertions

## Repository Structure 
```
istio-in-action/
├── cluster/ # kind cluster and Istio installation
├── apps/ # sample applications (Bookinfo, extensions)
├── scenarios/ # Istio production scenarios (core value)
├── automation/ # validation and testing of Istio behavior
├── gitops/ # Argo CD configuration and environments
├── docs/ # architecture notes and learning path
└── scripts/ # bootstrap and cleanup helpers
```

## Mileston Path 
This repository is intentially organized as a **progressive journey**. 

### Phase 1 -- Core Istio Capabilities
Focus: understanding and validating Istio behavior directly

- Traffic management (routing, retries, timeouts)
- Progressive delivery (canary, blue-green)
- Security (mTLS, authorization policies)
- Observability (metrics, tracing, access logs)

Artifacts live primarily under: 
- `cluster/`
- `apps/`
- `scenarios/`


### Phase 2 -- Production Automation & GitOps 
Focus: operating Istio at scale and with confidence.
- Automated traffic validation 
- Security regression detection 
- Git-driven mesh configuration 
- Argo CD-based delivery of Istio resources

Artifacts live primarily under: 
- `automation/`
- `gitops/`


## Scenarios (Production-Oriented)
Each scenario: 
- Targets a real production concern
- Is independently deployable 
- Includes verification and rollback guidance 

### 1. Traffic Management 
```
scenarios/01-traffic-management/
```

- Header-based routing (A/B testing)
- Canary releases with weighted traffic 
- Fault injection (latency, HTTP errors)
- Retry and timeout tuning
- Circuit breaking with outlier detection 

### 2. Deployment Strategies 
```
scenarios/02-deployment-strategies/
```

- Blue-Green deployments using Istio routing 
- Progressive delivery with traffic shifting 
- Safe rollback using destination rules 
- Version pinning and subset isolation 

### 3. Security & Zero Trust 
```
scenarios/03-security/
```
- Strict mTLS enforcement
- Namespace-level vs mesh-wide mTLS
- AuthorizationPolicy (RBAC-like controls)
- Service-to-service access boundaries
- Gradual mTLS migration strategy 

### 4. Observability & Diagnostics 
```
scenarios/04-observability/
```
- Distributed tracing with context propagation 
- Golden signals via Istio metrics 
- Access log configuration and analysis 
- Debugging traffic flows using telemetry

### 5. Resilience & Failure Handling 
```
scenarios/05-resilience
```

- Load shedding under failure 
- Failover between service versions 
- Handling partial outages 
- Chaos-style traffic experiments 

### 6. Ingress Migration: NGINX to Istio 
```
scenarios/06-ingress-migration/
```
- Baseline ingress using NGINX Ingress Controller 
- Traffic parity validation between NGINX and Istio 
- Incremental cutover to Istio Gateway 
- Zero-downtime migration startegy
- Rollback from Istio Gateway to NGINX
- Operational comparison: annotations vs Istio APIs

This scenario models a **realistic ingress migration path** commonly seen in existing Kubernetes platforms. 


### 7. Application Gateway Migration: Spring Cloud Gateway / Consul to Istio 
```
scenarios/07-app-gateway-migration/
```
This scenario focuses on migrating **application-layer gateway (Spring Cloud Gateway with Consul)** to Istio, while preserving deverloper experience and enabling gradual platform control. 

Key aspects: 
- Existing Spring Cloud Gateway with Consule service discovery 
- Local development without Istio dependencies 
- Kubernetes deployment with Istio sidecars and mesh routing 
- Gradual delegation of traffic control from application gateway to Istio 

Covered topics: 
- Mapping Spring Cloud Gateway routes to Istio VirtualService 
- Handling service discovery differences (Consul vs Kubernetes/Istio)
- Preserving local dev workflows (no Istio, no sidecar)
- Environment-based configuration isolation 
- Controlled feature overlap (what stays in the app vs what moves to the mesh)

This scenario models a **common brownfield migration** where platform teams adopt Istio without breaking existing developer workflows.

### 8. GitOps with Argo CD (Istio-Aware)
```
scenarios/08-gitops
```

- Managing Istio resources via Argo CD
- App-of-apps pattern for mesh configs 
- Progressive rollout driven by Git commits
- Safe promotion between environments. 

## GitOps Design (Argo CD + Istio)
Istio configuration is treated as **first-class GitOps-managed state**.

- VirtulServices, DestinationRules, and Policies are deployed declaratively.
- Environment overlays represents traffic intent, not just application state. 
- Rollbacks are Git-based and auditable

This avoids: 
- Manual kubectl-driven mesh drift
- Inconsistent traffic policies across environments. 


## Automation Strategy 
Automation validates **Istio behavior**, not just pod health.
Examples: 
- Assert traffic distribution percentages.
- Verify mTLS enforcement between services.
- Detect unauthorized access regressions.
- Confirm routing rules after GitOps sync 

Automation is intentionally decoupled from CI vendor specifics. 

## Intended Audience 
- Platform engineers
- Cloud-native developers 
- SREs adopting Istio 
- Engineers preparing for production Isito usage

## Disclaimer

This repository prioritizes clarity and correctness over completeness. Patterns demonstrated here should be adapted and hardened for real production use.

## Roadmap 
- Multi-cluster Istio scenarios 
- External traffic via Istio Gateway 
- Integration with progressive delivery tools
- Policy-as-code extensions 

## License
[LICENSE](./LICENSE)