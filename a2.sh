#!/usr/bin/env bash

echo
echo "=== Creating kind cluster, kind-1 ==="
echo
kind create cluster --name kind-1 --config k8s/kind/cluster-config.yaml

echo
echo "=== Checking if control plane is up ==="
echo
kubectl cluster-info
kubectl get nodes

echo
echo "=== Loading otot-a1_nodeserver Docker Image onto kind cluster ==="
echo
kind load docker-image otot-a1_nodeserver:latest --name kind-1

echo
echo "=== Deploying backend ==="
echo
kubectl apply -f k8s/manifests/backend-deployment.yaml

echo
echo "=== Create Ingress controller ==="
echo
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

echo
echo "=== Watching until Ingress is ready ==="
echo
kubectl -n ingress-nginx get deploy -w

echo
echo "=== Creating service ==="
echo
kubectl apply -f k8s/manifests/service.yaml

echo
echo "=== Creating Ingress object ==="
echo
kubectl apply -f k8s/manifests/ingress-object.yaml

echo
echo "=== Watching pod status ==="
echo
kubectl get pods -w