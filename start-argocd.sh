#!/bin/bash

# Set context name
CLUSTER_NAME="argocd-local"

# Create a local Kind cluster if not exists
kind get clusters | grep -q "$CLUSTER_NAME" || kind create cluster --name "$CLUSTER_NAME"

# Create Argo CD namespace
kubectl create namespace argocd || true

# Install Argo CD components
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for the Argo CD server to be ready
echo "Waiting for Argo CD server to be ready..."
kubectl wait deployment/argocd-server -n argocd --for=condition=available --timeout=180s

# Port forward to access the UI at localhost:8080
echo "Starting port-forwarding at https://localhost:8080 ..."
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
