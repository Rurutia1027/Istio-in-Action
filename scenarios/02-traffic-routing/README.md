# 02-traffic-routing 
**Purpose**: Deterministic routing rules 

Classic scenarios:
- Route by header 
- Route by user 
- Route by URI


Resources: 
- VirtualService 
- DestinationRule


#### Prerequisite - [Namespace](./namespace/namespace.yaml)

Purpose: 
- Defines the namespace that all apps and network configs works on 

#### Prerequisite - [DestinationRule](./network/destination-rule.yaml)

This must exist first, otherwise subset routing will not work 
Purpose: 
- Defines stable, named subsets
- Decoupled routing topic from Pod-level details 
- Required for any version-based routing 


--- 

## [Route by Header (Exact Match)](./network/vs-route-by-header.yaml)
### Scenario 
Route requests with a specific HTTP header to a fixed version.

Example: 
- Header: `x-env: test` -> `v2`
- All others -> `v1`

Use cases:
- Environment-based routing 
- Feature flags 
- Canary control via gateway / proxy injection 


--- 
## [Route by User](End-User Identity)
### Scenario 
Route traffic based on **authenticated user identity**
Istio automatically exposes: 
- `end-user` header (when auth is enabled)

Example: 
- User `jason` -> `v3`
- Others -> `v1`

Use cases: 
- Developer testing 
- VIP / internal user targeting 
- Debugging production behavior safely 


--- 

## [Route by URI (Path-Based Routing)]
### Scenario 
Route requests based on **request path**

Example: 
- `/reviews/special` -> `/v2`
- Everything else -> `v1`

Use Cases:
- API versioning 
- Feature-specific endpoints 
- Gradual rollout of new APIs 
