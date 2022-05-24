FROM docker.io/debian:stable-slim

# Inspired by jakejarvis/docker-cloudflare-argo Dockerfile 
# with some minor tweaks since I needed an entrypoint to run a custom config

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN ARCH="" && \
    case $(uname -m) in \
        x86_64) ARCH="amd64" ;; \
        aarch64) ARCH="arm64" ;; \
        *) echo "Unknown build architecture $(uname -m), quitting."; exit 2 ;; \
    esac && \
    wget -q https://github.com/cloudflare/cloudflared/releases/download/${CLOUDFLARED_VERSION:-../latest/download}/cloudflared-linux-${ARCH}.deb && \
    dpkg -i cloudflared-linux-${ARCH}.deb && \
    rm cloudflared-linux-${ARCH}.deb && \
    cloudflared --version

RUN mkdir -p /etc/cloudflared

COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]