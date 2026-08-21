# docker-rpi-ubuntu-kernel

Modified from https://github.com/carlonluca/docker-rpi-ubuntu-kernel
Updated for Resolute (26.04), added qemu-user-binfmt and other debugging tools needed 
by WSL2 when cross-building kernel modules.

Image to cross-build the Ubuntu kernel for the Raspberry Pi 5. 
The image contains all the needed tools here: https://hub.docker.com/r/tcwan/docker-rpi-ubuntu-26.04-kernel/

## Usage

From the host:

```
$ export PLATFORM=<amd64 | arm64>
$ docker pull tcwan/docker-rpi-ubuntu-26.04-kernel:$PLATFORM
$ cd <docker-rpi-ubuntu-kernel-gitrepo/path>
$ docker run {--rm} -it --name builder -v $PWD:/workspace \
    tcwan/docker-rpi-ubuntu-26.04-kernel:$PLATFORM /bin/bash
```

> Note: docker run with '--rm' will cause the container to be deleted after exiting. If you plan to use the container later after downloading the kernel source and customizing, don't enable this option.

From inside the running docker container:

```
# cd /usr/src
# git clone https://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux-raspi/+git/resolute linux
# git checkout master-next   # Needed for RPi5 latest kernels
[apply needed patches]
# cd /workspace; ln –s /usr/src/linux src
```

> Note: DO NOT clone the linux kernel source repository to the Windows NTFS or macOS APFS mapped folder.
NTFS and APFS are *case-insensitive* file systems, whereas Linux filesystems are *case-sensitive*.
There are some files in the linux kernel repository which will not clone correctly to a case-insensitive file system.

> The above location (/usr/src) is safe since it is located within the container's Linux filesystem

If you would like to modify the kernel configuration, uncomment the line in the build.sh script ending with 'editconfigs' 

## Kernel 7.x
In recent Ubuntu releases, (tested on 26.04), the realtime kernel is built alongside the normal kernel. This increases the Docker container storage footprint as well as lengthen the compile time.

To disable build of the realtime kernel:
```
- Edit /usr/src/linux/debian.raspi/rules.d/arm64.mk
- Remove raspi-realtime from flavours list

```

## Building

Now you can build the kernel by running the script in the container:
```
# ./build.sh
```
If you enabled 'editconfigs', the script will prompt you whether to modify the configuration for all available configs, including for aarch64.

If you managed to build the kernel successfully, in workspace/out you should get the packages to install in your pi:

```
# ls -lh /workspace/out
-rw-r--r-- 1 root root 1.1M Aug 21 01:39 linux-buildinfo-7.0.0-1017-raspi_7.0.0-1017.17_arm64.deb
-rw-r--r-- 1 root root 3.7M Aug 21 01:39 linux-headers-7.0.0-1017-raspi_7.0.0-1017.17_arm64.deb
-rw-r--r-- 1 root root  15M Aug 21 01:39 linux-image-7.0.0-1017-raspi_7.0.0-1017.17_arm64.deb
-rw-r--r-- 1 root root 145M Aug 21 01:39 linux-modules-7.0.0-1017-raspi_7.0.0-1017.17_arm64.deb
-rw-r--r-- 1 root root  15M Aug 21 00:43 linux-raspi-headers-7.0.0-1017_7.0.0-1017.17_arm64.deb
-rw-r--r-- 1 root root 851K Aug 21 00:44 linux-raspi-tools-7.0.0-1017_7.0.0-1017.17_arm64.deb
-rw-r--r-- 1 root root 607K Aug 21 01:39 linux-tools-7.0.0-1017-raspi_7.0.0-1017.17_arm64.deb
```
