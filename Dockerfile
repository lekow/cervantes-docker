FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base

EXPOSE 80
EXPOSE 443
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Cervantes.Web/Cervantes.Web.csproj", "Cervantes.Web/"]
COPY ["Cervantes.Application/Cervantes.Application.csproj", "Cervantes.Application/"]
COPY ["Cervantes.Contracts/Cervantes.Contracts.csproj", "Cervantes.Contracts/"]
COPY ["Cervantes.CORE/Cervantes.CORE.csproj", "Cervantes.CORE/"]
COPY ["Cervantes.DAL/Cervantes.DAL.csproj", "Cervantes.DAL/"]
COPY ["Cervantes.IFR/Cervantes.IFR.csproj", "Cervantes.IFR/"]
RUN dotnet restore "Cervantes.Web/Cervantes.Web.csproj"
COPY . .
WORKDIR "/src/Cervantes.Web"
RUN dotnet build "Cervantes.Web.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Cervantes.Web.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Cervantes.Web.dll"]

# set env variable in order for a non-interactive update process
ENV DEBIAN_FRONTEND=noninteractive

# update packets
RUN apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
# create new user with lower privileges
RUN useradd -ms /bin/bash cervantes
# change permissions of particular directories
RUN chown -R cervantes /app/wwwroot

# switch to the newly created user
USER cervantes
