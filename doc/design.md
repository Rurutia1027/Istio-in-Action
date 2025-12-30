# Bookinfo + Istio: Traffic & Observability Scenarios 
## Objective 
This document summarizes the key **Istio traffic management**, **security**, **observability**, and **fault injection scenarios** as they related to the Bookinfo application. The goal is to provide a reference for building **BDD automation tests**, capturing traffic flows, metrics, and expected system behaviors. 

## Core Istio Capabilities to Test 
### Traffic Management 
- **Virtual Services** & **Destination Rules**: Route requests based on hostname, path, or headers.
- **Traffic Splitting / A/B Testing**: Distribute traffic between service versions (v1, v2)
- **Canary Deployments**: Gradually shift traffic from v1 to v2
- **Retries, Timeouts, Circuit Breakers**: Validate service resilience under load 

### Security 
- **mTLS / Authentication**: Ensure secure service-to-service communication.
- **Authorization Policies**: Enforce which services can call which endpoints. 

### Observability 
- **Metrics/Telemetry**: Capture latency, throughput, and error rates via Prometheus.
- **Distributed Tracing**: Visualize request flows using Jaeger or Kiali 

### Fault Injection 
- Introduce **delays**, **aborts**, or **error responses** to test upstream service behavior and recovery. 


## Mapping Istio Scenarios to Bookinfo Services
Bookinfo provides a reference microservices application to exercise Istio features:

### Scenario-1: Default routing 
- **Traffic Flow**: `productpage` -> `defaults` / `reviews` -> `ratings`
- **Focus / BDD Validation**: Ensure correct aggregation and response data at the productpage UI.

### Scenario-2: Header-based routing 
- **Traffic Flow**: `productpage` -> `reviews`
- **Focus / BDD Validation**: Split traffic between reviews v1 and v2 based on headers (e.g., `User-Agent`)

### Scenario-3: Canary deployment
- **Traffic Flow**: `reviews v1` -> `reviews v2`
- **Focus / BDD Validation**: Gradually shift traffic; validate v2 receives correct request distribution

### Scenario-4: Fault injection
- **Traffic Flow**: Delay in `ratings` or abort in `details`
- **Focus / BDD Validation**:  Validate productpage error handling and latency impact

### Scenario-5: Traffic mirroring
- **Traffic Flow**: Mirror traffic to v2 while serving v1
- **Focus / BDD Validation**: Ensure mirrored requests do not affect end-user experience. 

## References
Key sections to review:
- Deploying the application
- Traffic routing rules
- Canary / A/B testing examples
- Fault injection strategies

## BDD Test Case Planning 
Each scenario maps to a **BDD feature**, which can be automated with Python or TypeScript + Playwright for frontend validation, and YAML/shell scripts for deployment control. 

### Example: Reviews Service Canary Deployment 
```gherkind 
Feature: Reviews service canary deployment
  Scenario: Split traffic 50/50 between v1 and v2
    Given Bookinfo services are deployed with Istio 
    When I send 100 requests to productpage with header "X-User: test"
    Then 50 requests should be served by reviews v1
    And 50 requests should be served by reviews v2  
```


### Notes
- Feature files can include **metrics assertions**: response times, error rate, throughput
- Tests can validate **end-to-end request paths**, service latency, and correct routing rules
- Observability tools (Prometheus, Kiali, Grafana) can be used to **verify traffic patterns** and **visualize metrics**.