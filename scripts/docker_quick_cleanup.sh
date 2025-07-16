#!/bin/bash

# Quick Docker Cleanup Script
# Simple script to remove all Docker containers and images

echo "🧹 Quick Docker Cleanup"
echo "======================="

# Show current Docker usage
echo "📊 Current Docker resources:"
echo "Containers: $(docker ps -a --format '{{.Names}}' | wc -l)"
echo "Images: $(docker images --format '{{.Repository}}:{{.Tag}}' | wc -l)"
echo "Volumes: $(docker volume ls -q | wc -l)"
echo ""

# Confirmation
echo "⚠️  This will remove ALL containers and images!"
read -p "Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Cancelled"
    exit 1
fi

# Stop all running containers
echo "🛑 Stopping all containers..."
docker stop $(docker ps -q) 2>/dev/null || echo "No running containers"

# Remove all containers
echo "🗑️  Removing all containers..."
docker rm $(docker ps -aq) 2>/dev/null || echo "No containers to remove"

# Remove all images
echo "🖼️  Removing all images..."
docker rmi $(docker images -q) -f 2>/dev/null || echo "No images to remove"

# Remove all volumes
echo "💾 Removing all volumes..."
docker volume rm $(docker volume ls -q) 2>/dev/null || echo "No volumes to remove"

# System cleanup
echo "🧹 Final system cleanup..."
docker system prune -af

echo ""
echo "✅ Cleanup completed!"
echo "📊 Remaining resources:"
docker system df
