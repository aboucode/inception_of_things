# K3s Kubernetes Learning Guide

## 🎯 Current Project Understanding

### What This Project Does:
1. **Creates 2 VMs** using Vagrant:
   - `abouassiS` (Master): Runs K3s server
   - `abouassiSW` (Worker): Runs K3s agent

2. **K3s Installation Process**:
   - Master installs K3s server with default settings
   - Generates a join token
   - Worker uses token to join the cluster

### Key Files Analysis:

#### Vagrantfile:
- Defines VM configurations
- Uses Alpine Linux (lightweight)
- Sets up private networking
- Mounts shared folder for token exchange

#### setup-master.sh:
- Installs K3s server
- Waits for token generation
- Saves token to shared folder

#### setup-worker.sh:
- Reads token from shared folder
- Installs K3s agent
- Joins master using K3S_URL and K3S_TOKEN

## 📚 Learning Path

### Phase 1: Basic Kubernetes Concepts (2-3 days)
1. **Core Concepts**:
   - Pods, Services, Deployments
   - Namespaces
   - ConfigMaps and Secrets
   - Nodes and Clusters

2. **Hands-on Practice**:
   ```bash
   # SSH to master
   vagrant ssh abouassiS
   
   # Check cluster status
   sudo k3s kubectl get nodes
   sudo k3s kubectl get pods --all-namespaces
   
   # Create your first pod
   sudo k3s kubectl run nginx --image=nginx
   sudo k3s kubectl get pods
   ```

### Phase 2: K3s Specifics (1-2 days)
1. **K3s vs K8s Differences**:
   - Lightweight (40MB binary)
   - SQLite as default datastore
   - Built-in ingress controller (Traefik)
   - Local storage provisioner

2. **K3s Components**:
   - Server (control plane)
   - Agent (worker)
   - Embedded etcd alternative

### Phase 3: Practical Exercises (3-4 days)

#### Exercise 1: Deploy a Simple Application
```bash
# Create a deployment
sudo k3s kubectl create deployment hello-world --image=gcr.io/google-samples/hello-app:1.0

# Expose it as a service
sudo k3s kubectl expose deployment hello-world --type=NodePort --port=8080

# Check the service
sudo k3s kubectl get services
```

#### Exercise 2: Use ConfigMaps and Secrets
```bash
# Create a ConfigMap
sudo k3s kubectl create configmap app-config --from-literal=env=production

# Create a Secret
sudo k3s kubectl create secret generic app-secret --from-literal=password=mysecret
```

#### Exercise 3: Persistent Storage
```bash
# Create a PVC (K3s has local-path storage by default)
cat <<EOF | sudo k3s kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
EOF
```

### Phase 4: Advanced Topics (2-3 days)
1. **Networking**:
   - CNI (Container Network Interface)
   - Service types (ClusterIP, NodePort, LoadBalancer)
   - Ingress controllers

2. **Security**:
   - RBAC (Role-Based Access Control)
   - Network policies
   - Pod security policies

3. **Monitoring & Logging**:
   - kubectl logs
   - kubectl describe
   - kubectl top (if metrics-server enabled)

## 🛠️ Recommended Tools to Install

### On Your Host Machine:
```bash
# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install k9s (terminal UI for Kubernetes)
curl -sS https://webi.sh/k9s | sh

# Install helm (package manager)
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

### Copy kubeconfig from VM:
```bash
# Get kubeconfig from master
vagrant ssh abouassiS -c "sudo cat /etc/rancher/k3s/k3s.yaml" > kubeconfig.yaml

# Edit the server IP (change from 127.0.0.1 to 192.168.56.110)
sed -i 's/127.0.0.1/192.168.56.110/g' kubeconfig.yaml

# Use it
export KUBECONFIG=$PWD/kubeconfig.yaml
kubectl get nodes
```

## 🧪 Testing Scenarios

### 1. Cluster Health Check
```bash
# Check nodes
sudo k3s kubectl get nodes -o wide

# Check system pods
sudo k3s kubectl get pods -n kube-system

# Check cluster info
sudo k3s kubectl cluster-info
```

### 2. Workload Testing
```bash
# Test scheduling on both nodes
sudo k3s kubectl create deployment test-app --image=nginx --replicas=3
sudo k3s kubectl get pods -o wide

# Check pod distribution across nodes
```

### 3. Network Testing
```bash
# Test pod-to-pod communication
sudo k3s kubectl run test-pod --image=busybox --rm -it -- wget -qO- http://service-ip:port
```

## 🔧 Troubleshooting Commands

```bash
# Check k3s service status
sudo service k3s status

# View k3s logs
sudo journalctl -u k3s -f

# Check node conditions
sudo k3s kubectl describe node abouassiS

# Debug pod issues
sudo k3s kubectl describe pod <pod-name>
sudo k3s kubectl logs <pod-name>reate deployment hello --image=nginx
abouassi@abouassi ~/Desktop/inseption_of_things/p1
 % - Deploy your first app: sudo k3s kubectl create deployment hello --image=nginx
```

## 📖 Additional Resources

1. **Official Documentation**:
   - [K3s Documentation](https://docs.k3s.io/)
   - [Kubernetes Documentation](https://kubernetes.io/docs/)

2. **Interactive Learning**:
   - [Kubernetes Bootcamp](https://kubernetesbootcamp.github.io/kubernetes-bootcamp/)
   - [Play with Kubernetes](https://labs.play-with-k8s.com/)

3. **Books**:
   - "Kubernetes Up & Running" by Kelsey Hightower
   - "Kubernetes in Action" by Marko Luksa

## 🎯 Next Steps After P1

1. **P2**: Likely involves application deployment
2. **P3**: Probably advanced features like ingress, monitoring
3. **Bonus**: Additional challenges

## 💡 Pro Tips

1. **Always check logs** when things don't work
2. **Use labels and selectors** for organizing resources
3. **Practice with YAML manifests** instead of just kubectl commands
4. **Understand the difference** between imperative and declarative approaches
5. **Learn to read kubectl describe output** for debugging
