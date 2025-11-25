# Wrapper to extend the base image

# Base image
ARG BASE_IMAGE=mcr.microsoft.com/devcontainers/base:ubuntu-22.04
FROM ${BASE_IMAGE}

# Default username (can be overridden during build)
ARG USERNAME=vscode

# Switch to root user
USER root

RUN groupmod --new-name "${USERNAME}" vscode && \
    usermod --login "${USERNAME}" --move-home --home "/home/${USERNAME}" vscode

# Install ARM toolchain and other dependencies as root
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        gcc-arm-none-eabi \
        gdb-multiarch \
        openocd \
        make \
        cmake \
        git \
        curl \
        wget \
        vim \
        nano \
        strace \
        htop \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Switch to the new user
USER "${USERNAME}"
