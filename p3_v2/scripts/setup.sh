#!/bin/bash
RED='\e[31m'
GREEN='\e[32m'
BLUE='\e[34m'
RESET='\e[0m'


if ! k3d cluster list | grep -q "abouassi-cluster"; then
    echo -e "${GREEN}Creating k3d cluster 'abouassi-cluster'...${RESET}"
    k3d cluster create abouassi-cluster  --port 8081:8888@loadbalancer
else
    echo -e "${GREEN}k3d cluster 'abouassi-cluster' already exists.${RESET}"
fi


# Wait for the cluster to be ready
echo -e "${BLUE}Waiting for the cluster to be ready...${RESET}"
until kubectl get nodes &> /dev/null; do
    sleep 1
done

echo -e "${GREEN}Cluster is ready!${RESET}"
# cluster info 
echo -e "${BLUE}Cluster Info:${RESET}"
k3d cluster list
kubectl get nodes



kubectl create namespace argocd

kubectl create namespace dev


# kubectl apply -f confs/wil-playground.yaml

# Install Argo CD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# # Wait for Argo CD to be ready
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd


# # Port forward to access Argo CD UI
# kubectl port-forward svc/argocd-server -n argocd 8080:443

# # Get initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > argocd_password.txt