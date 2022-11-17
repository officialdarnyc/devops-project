# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY ./dotnet/aspnetcore/functionApp/Application/*.sln .
COPY ./dotnet/aspnetcore/functionApp/Application/SampleFunctionApp/SampleFunctionApp.csproj aspnetapp/
RUN dotnet restore aspnetapp/SampleFunctionApp.csproj

# copy everything else and build app
COPY ./dotnet/aspnetcore/functionApp/Application/SampleFunctionApp/. aspnetapp/
WORKDIR /source/aspnetapp
RUN dotnet publish /source/aspnetapp/SampleFunctionApp.csproj -c release -o /app

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app .

ENTRYPOINT ["dotnet", "SampleFunctionApp.dll"]