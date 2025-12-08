# Wrapper to extend the base image

# Base image
ARG BASE_IMAGE=mcr.microsoft.com/devcontainers/base:ubuntu-24.04
FROM ${BASE_IMAGE}

# Default username (can be overridden during build)
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Switch to root user
USER root

# Copy the dependency files and packages
COPY scripts/dependencies.txt /tmp/dependencies.txt
COPY scripts/packages /tmp/packages

# Install packages from local .deb files
RUN apt-get update && \
    # Install dependencies that .deb files might need
    apt-get install -y --no-install-recommends --no-install-suggests \
        ca-certificates \
        locales \
        sudo \
    && \
    # Install all downloaded .deb packages
    apt install -y /tmp/packages/*.deb || true && \
    # Fix any missing dependencies
    apt-get install -f -y && \
    # Clean up
    rm -rf /tmp/packages /tmp/dependencies.txt && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN locale-gen --purge en_US.UTF-8 &&\
echo 'LANG="en_US.UTF-8"\nLANGUAGE="en_US"\n' > "/etc/default/locale"

# Create a new user with the specified username, UID, and GID
RUN groupmod --new-name "${USERNAME}" vscode &&\
    usermod --login "${USERNAME}" --move-home --home "/home/${USERNAME}" vscode

# Grant sudo access to the user
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USERNAME}" &&\
    chmod 0440 "/etc/sudoers.d/${USERNAME}"

# Set up ARM GCC toolchain
ARG WGET_LOCATION="/tmp/wget-download"
RUN mkdir -p "${WGET_LOCATION}"

ARG COMPILER_VERSION="14.3"
ARG COMPILER_TARGET_URL="https://developer.arm.com/-/media/Files/downloads/gnu/${COMPILER_VERSION}.rel1/binrel/arm-gnu-toolchain-${COMPILER_VERSION}.rel1-x86_64-arm-none-eabi.tar.xz"
ARG COMPILER_ARTIFACT_NAME="arm-toolchain.tar.xz"
ARG COMPILER_PATH="/opt/arm-toolchain"

RUN mkdir -p "${COMPILER_PATH}"

RUN wget "${COMPILER_TARGET_URL}" -O "${WGET_LOCATION}/${COMPILER_ARTIFACT_NAME}" &&\
    tar xJf "${WGET_LOCATION}/${COMPILER_ARTIFACT_NAME}" -C "${COMPILER_PATH}" &&\
    mv "${COMPILER_PATH}/arm-gnu-toolchain-${COMPILER_VERSION}.rel1-x86_64-arm-none-eabi/"* "${COMPILER_PATH}/" &&\
    rm -rf "${WGET_LOCATION}/${COMPILER_ARTIFACT_NAME}"

ENV PATH="${PATH}:${COMPILER_PATH}/bin"

# Set up Git hooks
ARG GIT_HOOKS_PATH="/opt/git-hooks"
RUN mkdir -p "${GIT_HOOKS_PATH}"
RUN  echo ${pwd}
COPY git/hooks "${GIT_HOOKS_PATH}"
RUN chmod -R +x "${GIT_HOOKS_PATH}"
RUN git config --system core.hooksPath "${GIT_HOOKS_PATH}"

# Switch to the new user
USER "${USERNAME}"
