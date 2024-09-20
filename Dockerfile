# Modified from https://github.com/carlonluca/docker-rpi-ubuntu-kernel
# Need to add qemu-user-binfmt for WSL2
# Added gdb-multiarch and telnet for kernel debugging using VSCode
# Ubuntu 24.04 changed the sources.list format
FROM ubuntu:24.04
ENTRYPOINT ["/bin/bash", "-l", "-c"]
WORKDIR /root
ADD ./*.cfg ./.gdbinit /root/

RUN sed -i -- 's/^Types: deb$/Types: deb deb-src/g' /etc/apt/sources.list.d/ubuntu.sources 
RUN \
    export DEBIAN_FRONTEND="noninteractive" && \
    apt-get -y update && \
    apt-get -y install fakeroot build-essential kexec-tools \
    kernel-wedge gcc-aarch64-linux-gnu libncurses6 libncurses-dev libelf-dev \
    asciidoc binutils-dev qemu-user-binfmt usbutils iputils-ping psmisc screen \
    git openssh-client gdb-multiarch telnet && \
    apt-get -y build-dep linux && \
    dpkg --add-architecture arm64
RUN \
    apt-get -y autoremove && \
    apt-get -y autoclean && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*
