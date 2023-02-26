ARG DEBIAN_RELEASE=bullseye
FROM docker.io/debian:$DEBIAN_RELEASE-slim
ARG DEBIAN_RELEASE
COPY pubkey.gpg entrypoint.sh /
ENV DEBIAN_FRONTEND noninteractive
RUN true && \
    curl https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
    apt update && \
    apt install -y gnupg musl ca-certificates libcap2-bin rinetd && \
    apt-key add /pubkey.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ jammy main" > /etc/apt/sources.list.d/cloudflare-client.list && \
    apt update && \
    apt install cloudflare-warp -y && \
    apt clean -y && \
    chmod +x /entrypoint.sh
COPY rinetd.conf /etc/rinetd.conf

EXPOSE 40000/tcp
ENTRYPOINT [ "/entrypoint.sh" ]

