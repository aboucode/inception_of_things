#!/bin/bash
# Practical exercises for learning K3s

echo "🎓 K3s Learning Exercises"
echo "========================"

echo "Choose an exercise:"
echo "1. Deploy Hello World App"
echo "2. Test Pod Communication"
echo "3. Create ConfigMap and Secret"
echo "4. Test Persistent Storage"
echo "5. View Cluster Resources"
echo "6. Cleanup Resources"

read -p "Enter choice (1-6): " choice

case $choice in
    1)
        echo "📦 Deploying Hello World App..."
        vagrant ssh abouassiS -c "sudo k3s kubectl apply -f /vagrant/examples/hello-world.yaml"
        echo "✅ Deployed! Check with: vagrant ssh abouassiS -c 'sudo k3s kubectl get all'"
        echo "🌐 Access at: http://192.168.56.110:30080"
        ;;
    2)
        echo "🔗 Testing Pod Communication..."
        vagrant ssh abouassiS -c "
        sudo k3s kubectl run test-pod --image=busybox --rm -it --restart=Never -- /bin/sh -c '
        echo Testing DNS resolution...
        nslookup kubernetes.default.svc.cluster.local
        echo Testing external connectivity...
        wget -qO- http://httpbin.org/ip 2>/dev/null || echo \"External connectivity test failed\"
        '"
        ;;
    3)
        echo "🔧 Creating ConfigMap and Secret..."
        vagrant ssh abouassiS -c "
        sudo k3s kubectl create configmap app-config --from-literal=environment=learning --from-literal=debug=true
        sudo k3s kubectl create secret generic app-secret --from-literal=username=student --from-literal=password=k3s-rocks
        sudo k3s kubectl get configmaps,secrets
        "
        ;;
    4)
        echo "💾 Testing Persistent Storage..."
        vagrant ssh abouassiS -c "
        cat <<EOF | sudo k3s kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: test-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 100Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: test-storage
spec:
  containers:
  - name: test
    image: busybox
    command: ['sh', '-c', 'echo Hello from persistent storage > /mnt/hello.txt && sleep 3600']
    volumeMounts:
    - name: storage
      mountPath: /mnt
  volumes:
  - name: storage
    persistentVolumeClaim:
      claimName: test-pvc
EOF
        echo 'Storage test deployed! Check with: sudo k3s kubectl get pvc,pods'
        "
        ;;
    5)
        echo "📊 Viewing Cluster Resources..."
        vagrant ssh abouassiS -c "
        echo '=== NODES ==='
        sudo k3s kubectl get nodes -o wide
        echo ''
        echo '=== PODS ==='
        sudo k3s kubectl get pods --all-namespaces
        echo ''
        echo '=== SERVICES ==='
        sudo k3s kubectl get svc --all-namespaces
        echo ''
        echo '=== PERSISTENT VOLUMES ==='
        sudo k3s kubectl get pv,pvc --all-namespaces
        "
        ;;
    6)
        echo "🧹 Cleaning up resources..."
        vagrant ssh abouassiS -c "
        sudo k3s kubectl delete deployment hello-world 2>/dev/null || true
        sudo k3s kubectl delete service hello-world-service 2>/dev/null || true
        sudo k3s kubectl delete pod test-storage 2>/dev/null || true
        sudo k3s kubectl delete pvc test-pvc 2>/dev/null || true
        sudo k3s kubectl delete configmap app-config 2>/dev/null || true
        sudo k3s kubectl delete secret app-secret 2>/dev/null || true
        echo 'Cleanup completed!'
        "
        ;;
    *)
        echo "Invalid choice!"
        ;;
esac
