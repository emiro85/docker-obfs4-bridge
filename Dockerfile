# Base docker image
FROM debian:stable-slim

# Set to 101 for backward compatibility
ARG UID=101
ARG GID=101

RUN apt-get update && apt-get install -y \
    curl \
    gpg \
    gpg-agent \
    ca-certificates \
    libcap2-bin \
    --no-install-recommends

RUN curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | tee /usr/share/keyrings/deb.torproject.org-keyring.gpg >/dev/null

RUN groupadd -g $GID debian-tor
RUN useradd -m -u $UID -g $GID -s /bin/false -d /var/lib/tor debian-tor

RUN printf "deb     [signed-by=/usr/share/keyrings/deb.torproject.org-keyring.gpg] https://deb.torproject.org/torproject.org bookworm main\n" >> /etc/apt/sources.list.d/tor.list
RUN printf "deb-src [signed-by=/usr/share/keyrings/deb.torproject.org-keyring.gpg] https://deb.torproject.org/torproject.org bookworm main\n" >> /etc/apt/sources.list.d/tor.list

RUN apt-get update && apt-get install -y \
    deb.torproject.org-keyring \
    obfs4proxy \
    tor \
    tor-geoipdb \
    --no-install-recommends

# Allow obfs4proxy to bind to ports < 1024.
#RUN setcap cap_net_bind_service=+ep /usr/bin/obfs4proxy

RUN chown -R debian-tor:debian-tor /etc/tor
RUN chown -R debian-tor:debian-tor /var/log/tor

COPY start-tor.sh /usr/local/bin
RUN chmod 0755 /usr/local/bin/start-tor.sh

COPY get-bridge-line /usr/local/bin
RUN chmod 0755 /usr/local/bin/get-bridge-line

USER debian-tor

CMD [ "/usr/local/bin/start-tor.sh" ]
