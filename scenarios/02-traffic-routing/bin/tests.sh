#!/bin/bash
set -euo pipefail        

# Should hit reviews v2
curl -s http://<NODE_IP>:30974/reviews/special | grep reviews

# Should hit reviews v1
curl -s http://<NODE_IP>:30974/reviews/normal | grep reviews


# Should hit reviews v2
curl -s -H "x-env: test" http://<NODE_IP>:30974/reviews/123 | grep reviews

# Should hit reviews v1
curl -s http://<NODE_IP>:30974/reviews/123 | grep reviews


# Should hit reviews v2
curl -s -H "x-env: test" http://<NODE_IP>:30974/reviews/123 | grep reviews

# Should hit reviews v1
curl -s http://<NODE_IP>:30974/reviews/123 | grep reviews


# Should hit reviews v3
curl -s -H "end-user: jason" http://<NODE_IP>:30974/reviews/123 | grep reviews

# Should hit reviews v1
curl -s -H "end-user: alice" http://<NODE_IP>:30974/reviews/123 | grep reviews
