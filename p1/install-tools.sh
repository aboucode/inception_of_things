#!/bin/bash
# Install useful Kubernetes tools for learning

echo "🛠️ Installing Kubernetes Learning Tools..."

# Install kubectl (official Kubernetes CLI)
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# Install k9s (terminal UI for Kubernetes)
echo "Installing k9s..."
curl -sS https://webi.sh/k9s | sh

# Install helm (Kubernetes package manager)
echo "Installing helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Setup kubeconfig to access cluster from host
echo "Setting up kubeconfig..."
cd /home/abouassi/Desktop/inseption_of_things/p1
vagrant ssh abouassiS -c "sudo cat /etc/rancher/k3s/k3s.yaml" > kubeconfig.yaml
sed -i 's/127.0.0.1/192.168.56.110/g' kubeconfig.yaml
echo "export KUBECONFIG=$PWD/kubeconfig.yaml" >> ~/.bashrc

echo "✅ Tools installed!"
echo ""
echo "To use kubectl from host machine:"
echo "export KUBECONFIG=/home/abouassi/Desktop/inseption_of_things/p1/kubeconfig.yaml"
echo "kubectl get nodes"
