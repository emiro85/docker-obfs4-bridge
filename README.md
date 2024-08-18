# docker-obfs4-bridge
This is an unofficial fork of docker-obfs4-bridge

Forked from upstream repository https://gitlab.torproject.org/tpo/anti-censorship/docker-obfs4-bridge and adjusted to my personal docker environment.

Relevant changes:
- amd64 only build based of debian:stable-slim
- Install obfs4proxy directly from torproject repo
- Require pre-existing torrc and data directory
- Do not allow ports below 1024
