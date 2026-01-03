# 03-Canary Deployment 
## Purpose 
Enable progressive delivery by controlling how traffic is shifted between service versions. This allows safe rollouts of new service versions with minimal risk.

## Classic Scenarios
- 90/10 rollout - direct 10% of traffic to the new version while keeping 90% on the stable version
- Gradual traffic shift - progressively increase traffic to the new version (e.g., 20 -> 50 -> 100%)

## Key Concepts
- **VirtualService**: Defines routing rules and traffic weights for service versions
- **DestinationRule**: Declares the different subsets (versions) of a service that can receive traffic 
- **Subset**: Each version of a service (v1, v2, v3, etc) must have a corresponding subset in the `DestinationRule`
- **Namespace Istolation**: Canary deployments should run in a dedicated namespace with Istio sidecar injection enabled to avoid conflicts which other scenarios 

## Resources / YAML files 
- `reviews-v1.yaml` - stable version deployment 
- `reviews-v2.yaml` - new version deployment 
- `reviews-service.yaml` - single Service for all versions 
- `destination-rule-reviews.yaml` - defines subsets for reviews v1/v2 
- `virtualservice-reviews.yaml` - routes traffic according to weights 


## Usage / Apply Order
- Ensure **Istio sidecar injection** is enabled for the namespace
- Deploy the **service versions** (v1, v2)
- Apply the **Service**
- Apply the **DestinationRule**
- Apply the **VirtualService**
- Adjust traffic weights as needed for canary rollout 

## Notes 
- Only the service being canaried (e.g., `reviews`) requires multiple versions; other Bookinfo services remain unchanged 
- Traffic weightsin the VirtualService can be updated dynamically using `kubectl apply` or automation tools like **Playweight** for BDD scenarios.