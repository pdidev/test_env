FROM debian:stable-slim

RUN apt-get update -qy \
 && apt-get install -qy --no-install-recommends \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    debian-archive-keyring \
    devscripts \
    equivs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

VOLUME /src
WORKDIR /src

COPY entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint"]
