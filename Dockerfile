FROM alpine:latest
ARG SERVERFILE=CryoFall_Server_v0.21.0.15_NetCore
RUN wget "https://atomictorch.com/Files/${SERVERFILE}.zip" && \
    unzip -d / "${SERVERFILE}.zip"

FROM mcr.microsoft.com/dotnet/core/runtime:2.1
ARG SERVERFILE=CryoFall_Server_v0.21.0.15_NetCore
ENV USER=cryofall USER_ID=65534 USER_GID=65534
RUN mkdir /CryoFall
COPY --from=0 /${SERVERFILE}/ /CryoFall/

RUN groupadd --gid "${USER_GID}" "${USER}" && \
    useradd \
      --uid ${USER_ID} \
      --gid ${USER_GID} \
      --create-home \
      --shell /bin/bash \
        ${USER}


COPY docker-entrypoint.sh /
RUN chmod u+x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
VOLUME [ "/CryoFall/Data" ]
EXPOSE 6000/udp