#!/bin/bash

# K3D Cleanup Script
# Remove k3d clusters and associated Docker resources

echo "🧹 K3D Cleanup Script"
echo "===================="

# Show current k3d clusters
echo "📊 Current k3d clusters:"
k3d cluster list

# Show current Docker containers related to k3d
echo ""
echo "🐳 K3D Docker containers:"
docker ps -a --filter "name=k3d" --format "table {{.Names}}\t{{.Status}}\t{{.Size}}"

echo ""
echo "⚠️  This will remove ALL k3d clusters and related Docker resources!"
read -p "Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Cancelled"
    exit 1
fi

# Stop all k3d clusters
echo "🛑 Stopping all k3d clusters..."
k3d cluster stop --all 2>/dev/null || echo "No clusters to stop"

# Delete all k3d clusters
echo "🗑️  Deleting all k3d clusters..."
k3d cluster delete --all 2>/dev/null || echo "No clusters to delete"

# Remove k3d-related Docker containers
echo "🐳 Removing k3d Docker containers..."
docker ps -aq --filter "name=k3d" | xargs docker rm -f 2>/dev/null || echo "No k3d containers to remove"

# Remove k3d-related Docker images
echo "🖼️  Removing k3d Docker images..."
docker images --filter "reference=rancher/k3s*" -q | xargs docker rmi -f 2>/dev/null || echo "No k3d images to remove"

# Remove k3d-related Docker volumes
echo "💾 Removing k3d Docker volumes..."
docker volume ls --filter "name=k3d" -q | xargs docker volume rm 2>/dev/null || echo "No k3d volumes to remove"

# Remove k3d-related Docker networks
echo "🌐 Removing k3d Docker networks..."
docker network ls --filter "name=k3d" -q | xargs docker network rm 2>/dev/null || echo "No k3d networks to remove"

echo ""
echo "✅ K3D cleanup completed!"
echo ""
echo "📊 Verification:"
echo "K3D clusters:"
k3d cluster list
echo ""
echo "Docker system usage:"
docker system df
