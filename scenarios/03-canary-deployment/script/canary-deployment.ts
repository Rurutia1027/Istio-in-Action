import fs from 'fs';
import path from 'path';
import https from 'https';

const namespace = '03-canary-deployment';
const httprouteName = 'ratings';
const kubeApiServer = process.env.K8S_API_SERVER;  
const token = process.env.K8S_TOKEN;            

if (!kubeApiServer || !token) {
  throw new Error('K8S_API_SERVER or K8S_TOKEN is not set.');
}

// Load JSON patch body
const patchBody = JSON.parse(
  fs.readFileSync(path.resolve(__dirname, 'httproute-patch.json'), 'utf-8')
);

const patchData = JSON.stringify(patchBody);

const options: https.RequestOptions = {
  method: 'PATCH',
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/merge-patch+json',
    'Content-Length': Buffer.byteLength(patchData),
  }
};

// Construct API path
const url = new URL(
  `/apis/gateway.networking.k8s.io/v1/namespaces/${namespace}/httproutes/${httprouteName}`,
  kubeApiServer
);

const req = https.request(url, options, res => {
  let data = '';
  res.on('data', chunk => data += chunk);
  res.on('end', () => {
    console.log(`Status: ${res.statusCode}`);
    console.log('Response:', data);
  });
});

req.on('error', err => {
  console.error('Error patching HTTPRoute:', err);
});

req.write(patchData);
req.end();