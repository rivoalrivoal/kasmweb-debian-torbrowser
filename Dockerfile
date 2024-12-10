FROM kasmweb/core-debian-bookworm:1.16.1

USER root

RUN echo "deb http://deb.debian.org/debian/ bookworm main contrib non-free" > /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y torbrowser-launcher

# Clean this because created by root (?)
RUN rm -rf /home/kasm-user/.local && \
    rm -rf /home/kasm-user/.cache

USER 1000