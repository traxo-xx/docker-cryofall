FROM alpine:latest
ARG SERVERFILE=CryoFall_Server_v0.21.0.12_NetCore
RUN wget "https://atomictorch.com/Files/${SERVERFILE}.zip" && \
    unzip -d / "${SERVERFILE}.zip"

FROM mcr.microsoft.com/dotnet/core/runtime:2.1
ARG SERVERFILE=CryoFall_Server_v0.21.0.12_NetCore
ARG UID=1001
ARG GID=1001
RUN mkdir /CryoFall
COPY --from=0 /${SERVERFILE}/ /CryoFall/
RUN chown -R ${UID}:${GID} /CryoFall/
USER ${UID}:${GID}
WORKDIR /CryoFall/Binaries/Server/
ENTRYPOINT ["dotnet", "CryoFall_Server.dll", "loadOrNew"]
VOLUME [ "/CryoFall/Data" ]
EXPOSE 6000/udp