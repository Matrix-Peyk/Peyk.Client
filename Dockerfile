FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app/


FROM microsoft/dotnet:2.2-sdk AS web-app-build
ARG configuration=Debug
WORKDIR /project/
COPY src src
RUN dotnet build src/Peyk.Client.Web/Peyk.Client.Web.csproj --configuration ${configuration}


FROM web-app-build AS publish
WORKDIR /project/
RUN dotnet publish src/Peyk.Client.Web/Peyk.Client.Web.csproj --configuration Release --output /app/


FROM base AS final
WORKDIR /app/
COPY --from=publish /app /app
CMD ASPNETCORE_URLS=http://+:${PORT:-80} dotnet Peyk.Client.Web.dll


FROM microsoft/dotnet:2.2-sdk AS solution-build
ARG configuration=Debug
WORKDIR /project/
COPY . .
RUN dotnet build Peyk.Client.sln --configuration ${configuration}
