# Use the official .NET 8 runtime as the base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /home/site/wwwroot
EXPOSE 80

# Use the .NET 8 SDK for building
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["EchoFunction.csproj", "./"]
RUN dotnet restore "EchoFunction.csproj"
COPY . .
RUN dotnet build "EchoFunction.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "EchoFunction.csproj" -c Release -o /app/publish

# Use the Azure Functions base image for .NET 8
FROM mcr.microsoft.com/azure-functions/dotnet-isolated:4-dotnet-isolated8.0 AS final
ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true

COPY --from=publish /app/publish /home/site/wwwroot