#!/bin/sh
set -e

# Parse the optional -j argument, which specifies the number of parallel jobs during make
while getopts "j:" opt; do
  case $opt in
    j) cpus=$OPTARG;;
    \?) echo "Usage: $0 [-j number_of_jobs]" >&2; exit 1;;
  esac
done

# If -j unspecified, default number of jobs is the number of processors
if [ -z "$cpus" ]; then
  cpus=$(nproc)
fi

# Download Buildroot
if [ ! -d buildroot ]; then
  curl https://buildroot.org/downloads/buildroot-2024.02.tar.xz | tar xJ
  mv buildroot-* buildroot
fi

# `make linux-savedefconfig` to save defconfig
# it's stored in buildroot/output/build/linux-custom/defconfig

cd buildroot
make -j "$cpus" defconfig BR2_EXTERNAL=../beepy_drivers BR2_DEFCONFIG=../br_defconfig
make -j "$cpus"
echo "Image built at buildroot/output/images/sdcard.img"

# After changing a br_defconfig option for a package, run `make <pkg>-dirclean>, then rebuild

# rm -rf output/target
# find output/ -name ".stamp_target_installed" -delete
# rm -f output/build/host-gcc-final-*/.stamp_host_installed
