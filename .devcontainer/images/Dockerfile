# Wrapper to extend the base image

# https://docs.docker.com/reference/dockerfile/#understand-how-arg-and-from-interact
# FROM instructions support variables that are declared by any ARG instructions that occur before the first FROM
ARG BASE_IMAGE
FROM ${BASE_IMAGE}
# An ARG declared before a FROM is outside of a build stage, so it can't be used in any instruction after a FROM
# To use the default value of an ARG declared before the first FROM use an ARG instruction without a value inside of a build stage
ARG BASE_IMAGE

ARG USERNAME

USER root

RUN groupmod --new-name "${USERNAME}" ubuntu &&\
    usermod --login "${USERNAME}" --move-home --home "/home/${USERNAME}" ubuntu

USER "${USERNAME}"
