# K3D Setup Guide - Complete Tutorial

# Step 1: Install k3d with sudo
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | sudo bash

# Verify installation
k3d version

# Step 2: Create a k3d cluster with 2 worker nodes

# Method 1: Command Line (Quick & Simple)
k3d cluster create dev-cluster --port "8080:80@loadbalancer" --port "8443:443@loadbalancer" --agents 2

# Method 2: YAML Configuration (Advanced & Reproducible)
# k3d cluster create --config k3d-simple-config.yaml
# k3d cluster create --config k3d-cluster-config.yaml

# Step 3: Configure kubectl
k3d kubeconfig merge dev-cluster --kubeconfig-merge-default

# Step 4: Verify cluster
kubectl get nodes
kubectl get pods --all-namespaces

# Step 5: Test cluster with a simple deployment
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer

# Step 6: Access your application
echo "Visit http://localhost:8080 to see your app"

# Common k3d commands:
# k3d cluster list                    # List clusters
# k3d cluster stop dev-cluster        # Stop cluster
# k3d cluster start dev-cluster       # Start cluster
# k3d cluster delete dev-cluster      # Delete cluster

# Advanced k3d cluster creation examples:
# k3d cluster create mycluster --servers 3 --agents 3                    # HA cluster
# k3d cluster create mycluster --registry-create myregistry              # With registry
# k3d cluster create mycluster --volume /host/path:/container/path        # With volume
# k3d cluster create mycluster --port 8080:80@loadbalancer --port 8443:443@loadbalancer

# Using YAML configs:
# k3d cluster create --config k3d-simple-config.yaml
# k3d cluster create --config k3d-cluster-config.yaml

# ====================
# CLEANUP SCRIPTS
# ====================

# Interactive cleanup menu
# ./cleanup_menu.sh

# Quick cleanup (removes everything)
# ./docker_quick_cleanup.sh

# Advanced cleanup with options
# ./docker_cleanup.sh --all

# K3D specific cleanup
# ./k3d_cleanup.sh

# Manual cleanup commands:
# docker stop $(docker ps -q)              # Stop all containers
# docker rm $(docker ps -aq)               # Remove all containers
# docker rmi $(docker images -q) -f        # Remove all images
# docker volume rm $(docker volume ls -q)  # Remove all volumes
# docker system prune -af                  # System cleanup