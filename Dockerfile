# =================
# Download
# =================
FROM alpine:3 AS download

RUN apk add --no-cache \
    wget \
    unzip
WORKDIR /download
RUN wget -qO ./DeceasedCraft-6.0.zip https://mediafilez.forgecdn.net/files/8448/977/DeceasedCraft_Server_Beta_5.10.17.zip \
    && unzip ./DeceasedCraft-6.0.zip -d . \
    && rm -f ./DeceasedCraft-6.0.zip

# =================
# Install
# =================
FROM eclipse-temurin:17-jre AS install

RUN mkdir -p /app && chown 1000:1000 /app

COPY --from=download --chown=1000:1000 ["/download", "/app"]

WORKDIR /app

RUN java -jar forge-1.20.1-47.4.0-installer.jar --installServer

COPY --chown=1000:1000 ["./patch/", "/app"]

# ===================
# Runtime
# ===================
FROM eclipse-temurin:17-jre

ENV TZ=Asia/Shanghai

RUN mkdir -p /app && chown 1000:1000 /app

COPY --from=install --chown=1000:1000 ["/app", "/app"]
COPY --chown=1000:1000 ["./init.sh", "/usr/local/bin/init.sh"]

EXPOSE 25565/tcp 25575/tcp

VOLUME [ "/app/world" ]

WORKDIR /app
USER 1000:1000
ENTRYPOINT [ "sh", "/usr/local/bin/init.sh" ]
CMD ["bash", "/app/start-server.sh"]
