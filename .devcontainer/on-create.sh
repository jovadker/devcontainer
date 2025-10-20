#!/bin/bash

# Install Azure Functions Core Tools
echo "Installing Azure Functions Core Tools..."
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -cs)-prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/dotnetdev.list'

sudo apt-get update
sudo apt-get install -y azure-functions-core-tools-4

# Install additional tools
echo "Installing additional development tools..."
sudo apt-get install -y \
    curl \
    wget \
    unzip \
    git \
    jq

# Verify installations
echo "Verifying installations..."
dotnet --version
func --version
az --version
docker --version
node --version
npm --version

echo "Development environment setup complete!"
echo ""
echo "Available commands:"
echo "  dotnet build              - Build the project"
echo "  func start                - Start Azure Functions locally"
echo "  docker build -t echo .    - Build Docker image"
echo "  docker run -p 8080:80 echo - Run container"
echo ""
echo "Access your function at:"
echo "  Local: http://localhost:7071/api/echo"
echo "  Docker: http://localhost:8080/api/echo"