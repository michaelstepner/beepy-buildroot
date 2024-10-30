# This Dockerfile is based on .github/workflows/build.yml and the official Buildroot Vagrantfile:
# https://gitlab.com/buildroot.org/buildroot/-/blob/master/support/misc/Vagrantfile

FROM ubuntu:24.04

# Copy the git repository to the container
COPY ../ /home/builder/beepy-buildroot

# Update and install necessary packages; create non-root user
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes \
    build-essential libncurses5-dev \
    git bzr cvs mercurial subversion libc6 unzip bc \
    make gcc g++ device-tree-compiler mtd-utils \
    wget curl file jq \
    cpio rsync \
    locales \
    && apt-get -q -y autoremove \
    && apt-get -q -y clean \
    && update-locale LC_ALL=C \
    && useradd -m -s /bin/bash builder \
    && passwd -d builder \
    && usermod -aG sudo builder \
    && mkdir -p /home/builder/beepy-buildroot \
    && chown -R builder:builder /home/builder

# Switch to the non-root user
USER builder
WORKDIR /home/builder/beepy-buildroot
