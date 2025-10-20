# Echo Azure Function - DevContainer

This folder contains the DevContainer configuration for GitHub Codespaces and VS Code Remote Development.

## What's Included

### Base Image
- **Microsoft .NET 8 DevContainer**: Pre-configured with .NET 8 SDK and runtime
- **Ubuntu 22.04 (Jammy)**: Latest LTS base system

### Features & Tools
- **Azure CLI**: For managing Azure resources
- **Docker-in-Docker**: For building and running containers
- **Node.js LTS**: For additional tooling and npm packages
- **Azure Functions Core Tools v4**: For local development and testing

### VS Code Extensions
- **C# Dev Kit**: Complete C# development experience
- **Azure Functions**: Azure Functions development tools
- **Docker**: Container management and development
- **PowerShell**: Script development support
- **GitHub Copilot**: AI-powered code assistance (if available)
- **YAML & JSON**: Configuration file support

### Port Forwarding
- **7071**: Azure Functions local development server
- **8080**: Docker container port

## Quick Start

1. **Open in Codespaces**: Click "Code" → "Codespaces" → "Create codespace on main"
2. **Wait for setup**: The environment will automatically install all dependencies
3. **Build the project**: `dotnet build`
4. **Run locally**: `func start`
5. **Test the API**: Send POST requests to `http://localhost:7071/api/echo`

## Available Commands

```bash
# Build the project
dotnet build

# Run Azure Functions locally
func start

# Build Docker image
docker build -t echo-function .

# Run Docker container
docker run -p 8080:80 echo-function

# Test the echo endpoint
curl -X POST http://localhost:7071/api/echo \
  -H "Content-Type: text/plain" \
  -d "Hello from Codespaces!"
```

## Environment Features

- **Automatic dependency installation**
- **Pre-configured VS Code settings**
- **Port forwarding for easy testing**
- **Docker support for containerization**
- **Azure integration for deployment**

## File Structure

```
.devcontainer/
├── devcontainer.json    # Main configuration
├── on-create.sh        # Setup script
└── README.md          # This file
```

The devcontainer automatically configures a complete Azure Functions development environment, so you can start coding immediately without any manual setup!