#!/bin/bash
# Install K3s on the master node
curl -sfL https://get.k3s.io | sh -

# Wait for k3s to be ready and token file to be created
echo "Waiting for k3s to initialize..."
while [ ! -f /var/lib/rancher/k3s/server/node-token ]; do
    sleep 2
    echo "Still waiting for k3s token..."
done

# Wait a bit more to ensure k3s is fully ready
sleep 5

TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)

# Ensure the /vagrant directory is writable and save the token
echo $TOKEN | sudo tee /vagrant/tokens/token > /dev/null
sudo chmod 644 /vagrant/tokens/token