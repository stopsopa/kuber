# DEPRECATED
Created in 2019 - quite old now and not maintained.
These were just some heavy experiments with kubernetes.

Nothing to be ashamed here:

I used best tools available at a time and delivered what's needed quickly.

# Installing

https://github.com/tomekwlod/kuber

Create at least two droplets in DO: `kuber-master`, `kuber-node-01`, ...

On a **master** node run:
- `cd /opt/kuber/master`
- `/bin/bash install.sh`
- copy the join command to paste it later to the nodes
- `/bin/bash user.sh`

On **the nodes**:
- `cd /opt/kuber/master`
- `/bin/bash install.sh`
- `/bin/bash user.sh`
- still as root run:
- previously copied join command
- if you haven't copied the join command do below:
   - `kubeadm token create --print-join-command`
   - paste and execute

<br />

# Usage
(Own registry: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)

<br />

```bash

kubectl run hw --image=image-here --port=80 (deprecated - use 'kubectl create' instead)
kubectl get deployments
kubectl get rs
kubectl get pods
kubectl expose deployment hw
kubectl expose deployment hw --type=NodePort
kubectl get services

```

# Kubernetes live test

```bash


docker build -t piiapp:0.0.1 .
docker-compose up

docker tag f27a644125ab sdpii/piiapp:0.0.3
docker push sdpii/piiapp:0.0.3


```

# Read more:
- https://kubernetes.io/blog/2015/10/some-things-you-didnt-know-about-kubectl_28/
- https://github.com/kubernetes/examples/tree/master/staging/cluster-dns
- (configure the nodes’ resolv.conf) https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/#known-issues
- https://kubernetes.io/docs/tasks/debug-application-cluster/get-shell-running-container/
- https://www.nginx.com/products/nginx/kubernetes-ingress-controller

# Detailed readme

[link](/DO/002-nginx-ingress%5Bhttps%5D)

