# docker-rpi-ubuntu-kernel

Modified from https://github.com/carlonluca/docker-rpi-ubuntu-kernel
Updated for Noble (24.04), added qemu-user-binfmt and other debugging tools needed 
by WSL2 when cross-building kernel modules.

Image to cross-build the Ubuntu kernel for the Raspberry Pi 5. 
The image contains all the needed tools here: https://hub.docker.com/r/tcwan/docker-rpi-ubuntu-24.04-kernel/

## Usage

From the host:

```
$ export PLATFORM=<amd64 | arm64>
$ docker pull tcwan/docker-rpi-ubuntu-24.04-kernel:$PLATFORM
$ cd <docker-rpi-ubuntu-kernel-gitrepo/path>
$ docker run --rm -it --name builder -v $PWD:/workspace \
    tcwan/docker-rpi-ubuntu-24.04-kernel:$PLATFORM /bin/bash
```

From inside the running docker container:

```
# cd /usr/src
# git clone https://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux-raspi/+git/noble linux
# git checkout master-next   # Needed for RPi5 latest kernels
[apply needed patches]
# cd /workspace; ln –s /usr/src/linux src
```

> Note: DO NOT clone the linux kernel source repository to the Windows NTFS or macOS APFS mapped folder.
NTFS and APFS are *case-insensitive* file systems, whereas Linux filesystems are *case-sensitive*.
There are some files in the linux kernel repository which will not clone correctly to a case-insensitive file system.

If you would like to modify the kernel configuration, uncomment the line in the build.sh script ending with 'editconfigs' 

Now you can build the kernel by running the script in the container:
```
# ./build.sh
```
If you enabled 'editconfigs', the script will prompt you whether to modify the configuration for all available configs, including for aarch64.

If you managed to build the kernel successfully, in workspace/out you should get the packages to install in your pi:

```
# ls -lh /workspace/out
total 156M
-rw-r--r-- 1 root root 1.5M Sep 20 02:40 linux-buildinfo-6.8.0-1010-raspi_6.8.0-1010.11_arm64.deb
-rw-r--r-- 1 root root 3.9M Sep 20 02:40 linux-headers-6.8.0-1010-raspi_6.8.0-1010.11_arm64.deb
-rw-r--r-- 1 root root  13M Sep 20 02:39 linux-image-6.8.0-1010-raspi_6.8.0-1010.11_arm64.deb
-rw-r--r-- 1 root root 124M Sep 20 02:40 linux-modules-6.8.0-1010-raspi_6.8.0-1010.11_arm64.deb
-rw-r--r-- 1 root root  14M Sep 20 01:38 linux-raspi-headers-6.8.0-1010_6.8.0-1010.11_arm64.deb
```
