FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
# Ensure we listen on any IP Address 
ENV DOTNET_URLS=http://+:7800
WORKDIR /app

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "dotnetasp-sigterm-demo.dll"]
