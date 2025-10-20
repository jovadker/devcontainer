# Echo Azure Function (.NET 8)

This is an Azure Function built with .NET 8 that provides a REST API endpoint to echo back posted messages. The function is containerized using Docker.

## Features

- **HTTP POST Endpoint**: `/api/echo`
- **Echo Functionality**: Returns the posted message with additional metadata
- **JSON Response**: Includes timestamp, request ID, and original message
- **Error Handling**: Proper error responses for invalid requests
- **Containerized**: Ready to run in Docker containers

## Project Structure

```
├── EchoFunction.cs          # Main function implementation
├── Program.cs               # Application entry point
├── EchoFunction.csproj      # Project file with dependencies
├── host.json                # Azure Functions host configuration
├── local.settings.json      # Local development settings
├── Dockerfile               # Docker container configuration
├── .dockerignore           # Docker build optimization
└── README.md               # This file
```

## API Endpoint

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

## Local Development

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

The function will be available at `http://localhost:7071/api/echo`

### Test the Function
```bash
# Using curl
curl -X POST http://localhost:7071/api/echo \
  -H "Content-Type: text/plain" \
  -d "Hello, Azure Functions!"

# Using PowerShell
Invoke-RestMethod -Uri "http://localhost:7071/api/echo" -Method Post -Body "Hello, Azure Functions!" -ContentType "text/plain"
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

The function will be available at `http://localhost:8080/api/echo`

### Test the Containerized Function
```bash
# Using curl
curl -X POST http://localhost:8080/api/echo \
  -H "Content-Type: text/plain" \
  -d "Hello from Docker!"

# Using PowerShell
Invoke-RestMethod -Uri "http://localhost:8080/api/echo" -Method Post -Body "Hello from Docker!" -ContentType "text/plain"
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