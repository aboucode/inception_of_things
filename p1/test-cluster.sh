#!/bin/bash
# Test script to verify your K3s cluster is working

echo "🔍 Testing K3s Cluster Health..."
echo "=================================="

echo "1. Checking cluster nodes:"
vagrant ssh abouassiS -c "sudo k3s kubectl get nodes -o wide"

echo ""
echo "2. Checking system pods:"
vagrant ssh abouassiS -c "sudo k3s kubectl get pods --all-namespaces"

echo ""
echo "3. Checking cluster info:"
vagrant ssh abouassiS -c "sudo k3s kubectl cluster-info"

echo ""
echo "4. Testing a simple deployment:"
vagrant ssh abouassiS -c "sudo k3s kubectl create deployment test-nginx --image=nginx --dry-run=client -o yaml" > /tmp/test-deployment.yaml

echo ""
echo "5. Cluster resource usage:"
vagrant ssh abouassiS -c "sudo k3s kubectl top nodes 2>/dev/null || echo 'Metrics not available (normal for basic setup)'"

echo ""
echo "✅ Cluster test completed!"
echo ""
echo "Next steps:"
echo "- SSH to master: vagrant ssh abouassiS"
echo "- Try: sudo k3s kubectl get all --all-namespaces"
echo "- Deploy your first app: sudo k3s kubectl create deployment hello --image=nginx"
