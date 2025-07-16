#!/bin/bash

set -e

echo "📦 Updating existing packages..."
sudo apt update

echo "🛠️ Installing required dependencies..."
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common \
    lsb-release

echo "🔑 Adding Docker’s GPG key..."
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

echo "📋 Verifying the key fingerprint..."
sudo apt-key fingerprint 0EBFCD88

echo "📦 Adding Docker APT repository for Debian Buster..."
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

echo "🔁 Updating APT package index again..."
sudo apt update

echo "🐳 Installing Docker Engine..."
sudo apt install -y docker-ce docker-ce-cli containerd.io

echo "👤 Adding current user '$USER' to docker group..."
sudo usermod -aG docker $USER

echo "✅ Docker installation complete!"
echo "👉 Please log out and back in or run: newgrp docker"


