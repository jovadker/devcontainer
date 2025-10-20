# Echo Azure Function (.NET 8)

This is an Azure Function built with .NET 8 that provides a REST API endpoint to echo back posted messages. The function is containerized using Docker.

## Features

- **HTTP POST Endpoint**: `/api/echo`
- **HTTP GET Endpoint**: `/api/datetime`
- **Echo Functionality**: Returns the posted message with additional metadata
- **DateTime Functionality**: Returns current UTC datetime in multiple formats
- **JSON Response**: Includes timestamp, request ID, and original message
- **Error Handling**: Proper error responses for invalid requests
- **Containerized**: Ready to run in Docker containers
- **DevContainer**: GitHub Codespaces and VS Code Remote Development ready

## Project Structure

```
├── .devcontainer/          # GitHub Codespaces configuration
│   ├── devcontainer.json   # DevContainer configuration
│   ├── on-create.sh       # Environment setup script
│   └── README.md          # DevContainer documentation
├── EchoFunction.cs          # Main function implementation
├── Program.cs               # Application entry point
├── EchoFunction.csproj      # Project file with dependencies
├── host.json                # Azure Functions host configuration
├── local.settings.json      # Local development settings
├── Dockerfile               # Docker container configuration
├── .dockerignore           # Docker build optimization
└── README.md               # This file
```

## API Endpoints

### POST /api/echo

Echoes back the posted message with additional metadata.

**Request:**
- Method: `POST`
- URL: `http://localhost:7071/api/echo` (local) or your deployed URL
- Content-Type: Any
- Body: Any text content

**Response:**
```json
{
  "message": "Echo successful",
  "originalMessage": "Your posted content here",
  "timestamp": "2025-10-20T10:30:00.000Z",
  "requestId": "12345678-1234-1234-1234-123456789012"
}
```

### GET /api/datetime

Returns the current UTC datetime in multiple formats.

**Request:**
- Method: `GET`
- URL: `http://localhost:7071/api/datetime` (local) or your deployed URL
- No body required

**Response:**
```json
{
  "message": "Current UTC DateTime",
  "utcDateTime": "2025-10-20T10:30:00.1234567Z",
  "timestamp": "2025-10-20T10:30:00.1234567Z",
  "unixTimestamp": 1729420200,
  "requestId": "12345678-1234-1234-1234-123456789012"
}
```

## Development Options

### GitHub Codespaces (Recommended)

The easiest way to get started is using GitHub Codespaces:

1. Click the **"Code"** button on the GitHub repository
2. Select **"Codespaces"** tab
3. Click **"Create codespace on main"**
4. Wait for the environment to set up automatically
5. Start developing immediately!

The devcontainer includes:
- .NET 8 SDK pre-installed
- Azure Functions Core Tools v4
- Docker support
- All required VS Code extensions
- Pre-configured debugging

### Local Development

### Prerequisites
- .NET 8 SDK
- Azure Functions Core Tools v4

### Run Locally
```bash
# Restore dependencies
dotnet restore

# Run the function
func start
```

The function will be available at `http://localhost:7071/api/echo` and `http://localhost:7071/api/datetime`

### Test the Functions
```bash
# Test Echo function using curl
curl -X POST http://localhost:7071/api/echo \
  -H "Content-Type: text/plain" \
  -d "Hello, Azure Functions!"

# Test DateTime function using curl
curl -X GET http://localhost:7071/api/datetime

# Using PowerShell - Echo function
Invoke-RestMethod -Uri "http://localhost:7071/api/echo" -Method Post -Body "Hello, Azure Functions!" -ContentType "text/plain"

# Using PowerShell - DateTime function
Invoke-RestMethod -Uri "http://localhost:7071/api/datetime" -Method Get
```

## Docker Deployment

### Build the Docker Image
```bash
docker build -t echo-function .
```

### Run the Container
```bash
docker run -p 8080:80 echo-function
```

The function will be available at `http://localhost:8080/api/echo` and `http://localhost:8080/api/datetime`

### Test the Containerized Functions
```bash
# Test Echo function using curl
curl -X POST http://localhost:8080/api/echo \
  -H "Content-Type: text/plain" \
  -d "Hello from Docker!"

# Test DateTime function using curl
curl -X GET http://localhost:8080/api/datetime

# Using PowerShell - Echo function
Invoke-RestMethod -Uri "http://localhost:8080/api/echo" -Method Post -Body "Hello from Docker!" -ContentType "text/plain"

# Using PowerShell - DateTime function
Invoke-RestMethod -Uri "http://localhost:8080/api/datetime" -Method Get
```

## Deployment to Azure

### Using Azure Container Instances (ACI)
```bash
# Build and tag for Azure Container Registry
docker build -t myregistry.azurecr.io/echo-function:latest .
docker push myregistry.azurecr.io/echo-function:latest

# Deploy to Azure Container Instances
az container create \
  --resource-group myResourceGroup \
  --name echo-function-aci \
  --image myregistry.azurecr.io/echo-function:latest \
  --dns-name-label echo-function-unique \
  --ports 80
```

### Using Azure Container Apps
```bash
# Create Container App
az containerapp create \
  --name echo-function-app \
  --resource-group myResourceGroup \
  --environment myContainerAppEnv \
  --image myregistry.azurecr.io/echo-function:latest \
  --target-port 80 \
  --ingress external
```

## Configuration

### Environment Variables
- `AzureWebJobsStorage`: Azure Storage connection string (required for Azure deployment)
- `FUNCTIONS_WORKER_RUNTIME`: Set to `dotnet-isolated`

### Application Insights
The function includes Application Insights integration for monitoring and logging. Configure the `APPINSIGHTS_INSTRUMENTATIONKEY` or `APPLICATIONINSIGHTS_CONNECTION_STRING` environment variable for telemetry.

## Error Handling

The function includes comprehensive error handling:
- **400 Bad Request**: When request body is empty
- **500 Internal Server Error**: For unexpected errors
- **200 OK**: Successful echo response

## Logging

The function uses structured logging with different log levels:
- Information logs for successful requests
- Error logs for exceptions
- Application Insights integration for telemetry

## Security

- The function uses `AuthorizationLevel.Anonymous` for easy testing
- For production use, consider changing to `AuthorizationLevel.Function` or implementing custom authentication
- HTTPS is recommended for production deployments