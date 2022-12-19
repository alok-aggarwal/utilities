FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install curl libmagic1 -y && \
    apt-get install rpm -y && \
    mkdir -p /var/lib/lacework/config && \
    mkdir -p /var/log/lacework && \
    mkdir -p /laceworkfim && \
    apt-get clean && \
    rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /usr/share/man \
    /usr/share/doc \
    /usr/share/doc-base

