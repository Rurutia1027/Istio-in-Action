# Istio -- Traffic Routing Concepts 
Traffic routing is one of the core Istio features, and it's the basis for almost every advanced scenario (A/B testing, canary deployments, blue/green, etc.). Here's a comprehensive note for our `02-traffic-routing` folder. 

## Core Resources for Traffic Routing 
### Istio CRD: VirtualService 
- Purpose: Defines **how requests are routed** to one or multiple services or subsets(versions)
- Notes: Core for traffic splitting, weighted routing, etc. 

### Istio CRD: DestinationRule 
- Purpose: Defines **policies for the target services** (subset, connection pool, load balancing, mTLS settings) 
- Notes: Works together with VirtualService to control traffic to version 

### Istio CRD: Gateway 
- Purpose: Configures **ingress**/**egress points** of the mesh at the L7 HTTP/HTTPS layer 
- Notes: Can expose traffic to external clients 

### Istio CRD: ServiceEntry 
- Purpose: Allows traffic to **External services outside the mesh**
- Notes: Optional for routing traffic outside the cluster 

### Istio CRD: EnvoyFilter (advanced)
- Purpose: Fine-grained control over traffic behavior at the proxy level 
- Notes: Only for edge cases, debugging, or protocol tweaks 

## Key Traffic Routing Concepts 
### Subset / Versioning 
- Use labels like `version: v1`, `version: v2` to define subsets in **DestinationRule**
- VirtualService can route a percentage of traffic to each subset

### Weighted Routing 
- Split traffic, e.g., 90% v1, 10% v2 for canary testing 
- Defined in VirtualService -> http -> route -> weight 

### HTTP / TCP Routing 
- VirtualService supports L7 routing (path-based, header-based)
- Can also handle TCP routes if needed 

### Gateway + Ingress 
- External traffic enters mesh via **Gateway**
- VirtualService attached to Gateway defines host/path routing 

### Retries, Timeouts, Failover 
- Basic routing can include **retries**, **timeout policies**, **fault injection** (later scenarios) 
- DestinationRule can define **connection pool settings** to manage traffic behavior

### Traffic Mirroring (useful for testing/todo)
- Send a copy of live traffic to a new version (for testing)
- Done in VirtualService with `mirror:` field 


---

## What YAML files to create for this scenario 

### `destinationrule-reviews.yaml`

- Define subsets of reviews service (v1, v2, and v3)
- Enable traffic splitting 

### `virtualservice-reviews.yaml`
- Route traffic to different subsets (weighted routing)
- Path/header-based routing if needed 

### `gateway.yaml`
- Expose productpage to external clients 
- Only if we want external traffic access 