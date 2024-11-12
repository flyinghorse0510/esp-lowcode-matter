FROM ubuntu:22.04

ARG VERSION=latest

RUN set -x \
    && useradd -s /bin/bash -g root -u 1001 -m espressif \
    && echo "espressif:espressif" | chpasswd \
    && chown -R espressif /home/espressif/ \
    && : # last line

USER espressif

WORKDIR /home/espressif/esp
ENV REPOS_PATH=/home/espressif/esp
ENV IDF_PATH=$REPOS_PATH/esp-idf
ENV ESP_AMP_PATH=$REPOS_PATH/esp-amp
ENV LOWCODE_PATH=$REPOS_PATH/esp-lowcode-matter
ENV LOWCODE_DEPENDENCIES_PATH=$LOWCODE_PATH/tools/dependencies
ENV ESP_MATTER_PATH=$LOWCODE_DEPENDENCIES_PATH/esp-matter
ENV ESP_RMAKER_PATH=$LOWCODE_DEPENDENCIES_PATH/esp-rainmaker
ENV ESP_SECURE_CERT_PATH=$LOWCODE_DEPENDENCIES_PATH/esp_secure_cert_mgr
ENV MATTER_ONE_PATH=$LOWCODE_DEPENDENCIES_PATH/matter-one

ARG IDF_BRANCH=release/v5.3
ARG ESP_AMP_BRANCH=main
ARG LOWCODE_BRANCH=main

RUN set -x \
    && mkdir -p $REPOS_PATH \

    && cd $REPOS_PATH \
    && mkdir esp-idf-release-v5.3 \
    && cd esp-idf-release-v5.3 \
    && echo "test1" > test.txt \
    && cd .. \

    && cd $REPOS_PATH \
    && mkdir esp-amp \
    && cd esp-amp \
    && echo "test2" > test.txt \
    && cd .. \

    && cd $REPOS_PATH \
    && mkdir esp-lowcode-matter \
    && cd esp-lowcode-matter \
    && echo "test3" > test.txt \
    && cd .. \

    && : # last line
