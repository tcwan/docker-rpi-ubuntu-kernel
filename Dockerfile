# Modified from https://github.com/carlonluca/docker-rpi-ubuntu-kernel
# Need to add qemu-user-binfmt for WSL2
FROM ubuntu:22.04
ENTRYPOINT ["/bin/bash", "-l", "-c"]
WORKDIR /root

RUN sed -i -- 's/#deb-src/deb-src/g' /etc/apt/sources.list && sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list
RUN \
    export DEBIAN_FRONTEND="noninteractive" && \
    apt-get -y update && \
    apt-get -y install fakeroot build-essential kexec-tools \
    kernel-wedge gcc-aarch64-linux-gnu libncurses5 libncurses5-dev libelf-dev asciidoc binutils-dev qemu-user-binfmt && \
    apt-get -y build-dep linux && \
    dpkg --add-architecture arm64
RUN \
    apt-get -y autoremove && \
    apt-get -y autoclean && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*
