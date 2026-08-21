#!/bin/bash
# To customize the kernel build settings, uncomment the editconfigs line

cd /workspace/src
mkdir -p /workspace/out
export CC=aarch64-linux-gnu-gcc
export $(dpkg-architecture -aarm64); export CROSS_COMPILE=aarch64-linux-gnu-
fakeroot debian/rules clean

# To modify Kernel configs, uncomment the editconfigs line
#fakeroot debian/rules editconfigs

# To generate dbgsyms, set do_full_build=true
# This will also generate source packages. The generated files are huge!
#fakeroot debian/rules binary-headers binary binary-perarch do_full_build=true
fakeroot debian/rules binary-headers binary binary-perarch 

mv ../*deb /workspace/out/
echo "Done ;-)"
