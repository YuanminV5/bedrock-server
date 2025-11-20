#!/bin/bash

# Build script for Minecraft Bedrock Server Docker Image

echo "Building Minecraft Bedrock Server Docker Image..."

# Build the Docker image
docker build -t minecraft-bedrock-server:latest .

if [ $? -eq 0 ]; then
    echo "✅ Docker image built successfully!"
    echo ""
    echo "To run the server, use one of these commands:"
    echo ""
    echo "Using Docker Compose (recommended):"
    echo "  docker-compose up -d"
    echo ""
    echo "Using Docker directly:"
    echo "  docker run -d --name minecraft-bedrock -p 19132:19132/udp -p 19133:19133/udp minecraft-bedrock-server:latest"
    echo ""
else
    echo "❌ Failed to build Docker image!"
    exit 1
fi