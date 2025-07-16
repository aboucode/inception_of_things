#!/bin/bash
# Install K3s on the master node
curl -sfL https://get.k3s.io | sh -



# Wait a bit more to ensure k3s is fully ready


echo "🚀 P2 Auto-Deployment Script"
echo "============================"

# Wait for k3s to be ready
echo "Waiting for k3s to be fully ready..."
while ! sudo k3s kubectl get nodes &>/dev/null; do
    sleep 2
done

echo "✅ K3s is ready!"

sleep 5
sudo chmod 644 /etc/rancher/k3s/k3s.yaml
# Deploy all applications
echo "📦 Deploying applications..."
sudo k3s kubectl apply -f /vagrant/confs/

# Wait for deployments
# echo "⏳ Waiting for deployments to be ready..."
# sudo k3s kubectl wait --for=condition=available --timeout=300s deployment/app1
# sudo k3s kubectl wait --for=condition=available --timeout=300s deployment/app2  
# sudo k3s kubectl wait --for=condition=available --timeout=300s deployment/app3

# echo "✅ All applications deployed successfully!"

# # Show status
# echo ""
# echo "📊 Deployment Status:"
# sudo k3s kubectl get deployments,services,ingress,pods

# echo ""
# echo "🌐 Access URLs:"
# echo "App1: curl -H 'Host: app1.com' http://192.168.56.110"
# echo "App2: curl -H 'Host: app2.com' http://192.168.56.110"  
# echo "App3: curl http://192.168.56.110"

# echo ""
# echo "🎯 To test from outside the VM, add to /etc/hosts:"
# echo "192.168.56.110 app1.com"
# echo "192.168.56.110 app2.com"

