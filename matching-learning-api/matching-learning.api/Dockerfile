FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["matching-learning.api/matching-learning.api.csproj", "matching-learning.api/"]
RUN dotnet restore "matching-learning.api/matching-learning.api.csproj"
COPY . .
WORKDIR "/src/matching-learning.api"
RUN dotnet build "matching-learning.api.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "matching-learning.api.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "matching-learning.api.dll"]