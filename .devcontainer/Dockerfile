FROM ubuntu:focal

RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -fy \
    autoconf \
    automake \
    bison \
    bridge-utils \
    ccache \
    clang \
    clang-format \
    clang-tidy \
    curl \
    flex \
    g++ \
    git \
    gperf \
    iproute2 \
    jq \
    lcov \
    libavahi-client-dev \
    libavahi-common-dev \
    libcairo2-dev \
    libdbus-1-dev \
    libdbus-glib-1-dev \
    libdmalloc-dev \
    libgif-dev \
    libglib2.0-dev \
    libical-dev \
    libjpeg-dev \
    libmbedtls-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libnl-3-dev \
    libnl-route-3-dev \
    libnspr4-dev \
    libpango1.0-dev \
    libpixman-1-dev \
    libreadline-dev \
    libssl-dev \
    libtool \
    libudev-dev \
    libusb-1.0-0 \
    libusb-dev \
    libxml2-dev \
    make \
    net-tools \
    ninja-build \
    openjdk-8-jdk \
    pkg-config \
    python3.9 \
    python3.9-dev \
    python3.9-venv \
    rsync \
    shellcheck \
    strace \
    systemd \
    udev \
    unzip \
    wget \
    git-lfs \
    zlib1g-dev \
    zip unzip \
    openssh-server \
    openjdk-11-jdk \
    sudo \
    && rm -rf /var/lib/apt/lists/ \
    && : # last line

RUN set -x \
    && (cd /tmp \
    && wget --progress=dot:giga https://github.com/Kitware/CMake/releases/download/v3.19.3/cmake-3.19.3-Linux-x86_64.sh \
    && sh cmake-3.19.3-Linux-x86_64.sh --exclude-subdir --prefix=/usr/local \
    && rm -rf cmake-3.19.3-Linux-x86_64.sh) \
    && exec bash \
    && : # last line

RUN set -x \
    && DEBIAN_FRONTEND=noninteractive  apt-get update \
    && DEBIAN_FRONTEND=noninteractive  apt-get install -y libgirepository1.0-dev \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common \
    && add-apt-repository universe \
    && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python3.9 get-pip.py \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1 \
    && rm -rf /var/lib/apt/lists/ \
    && : # last line

ARG VERSION=latest

RUN set -x \
    && useradd -s /bin/bash -g root -u 1001 -m espressif \
    && echo "espressif:espressif" | chpasswd \
    && chown -R espressif /home/espressif/ \
    && : # last line

USER espressif

WORKDIR /home/espressif/esp

ARG IDF_BRANCH=release/v5.3
ARG ESP_AMP_BRANCH=main
ARG LOWCODE_BRANCH=main

ENV REPOS_PATH=/home/espressif/esp
ENV IDF_PATH=$REPOS_PATH/esp-idf-release-v5.3
ENV ESP_AMP_PATH=$REPOS_PATH/esp-amp
ENV LOW_CODE_PATH=$REPOS_PATH/tmp/esp-lowcode-matter

ENV LOW_CODE_DEPENDENCIES_PATH=$LOW_CODE_PATH/tools/dependencies
ENV ESP_MATTER_PATH=$LOW_CODE_DEPENDENCIES_PATH/esp-matter
ENV ZAP_INSTALL_PATH=$ESP_MATTER_PATH/connectedhomeip/connectedhomeip/.environment/cipd/packages/zap
ENV ESP_RMAKER_PATH=$LOW_CODE_DEPENDENCIES_PATH/esp-rainmaker
ENV ESP_SECURE_CERT_PATH=$LOW_CODE_DEPENDENCIES_PATH/esp_secure_cert_mgr
ENV MATTER_ONE_PATH=$LOW_CODE_DEPENDENCIES_PATH/matter-one

RUN set -x \
    && cd $REPOS_PATH \
    && idf_repo_name=esp-idf-$(echo $IDF_BRANCH | sed 's/\//-/g') \
    && git clone --single-branch -b $IDF_BRANCH --depth 1 https://github.com/espressif/esp-idf.git $idf_repo_name \
    && cd $idf_repo_name \
    && git submodule update --init --depth 1 \
    && ./install.sh esp32c6 \
    && . ./export.sh \
    && cd .. \

    && cd $REPOS_PATH \
    && git clone --single-branch -b $ESP_AMP_BRANCH --depth 1 https://github.com/chiragatal/esp-amp.git \
    && cd esp-amp \
    && git submodule update --init --depth 1 \
    && cd .. \

    && cd $REPOS_PATH \
    && mkdir tmp \
    && cd tmp \
    && git clone --single-branch -b $LOWCODE_BRANCH --depth 1 https://github.com/chiragatal/esp-lowcode-matter.git \
    && cd esp-lowcode-matter \
    && git submodule update --init --depth 1 \
    && ./install.sh \
    && . ./export.sh \
    && cd ../.. \

    && : # last line

ENV LOW_CODE_PATH=$REPOS_PATH/esp-lowcode-matter
ENV LOW_CODE_DEPENDENCIES_PATH=$LOW_CODE_PATH/tools/dependencies
ENV ESP_MATTER_PATH=$LOW_CODE_DEPENDENCIES_PATH/esp-matter
ENV ZAP_INSTALL_PATH=$ESP_MATTER_PATH/connectedhomeip/connectedhomeip/.environment/cipd/packages/zap
ENV ESP_RMAKER_PATH=$LOW_CODE_DEPENDENCIES_PATH/esp-rainmaker
ENV ESP_SECURE_CERT_PATH=$LOW_CODE_DEPENDENCIES_PATH/esp_secure_cert_mgr
ENV MATTER_ONE_PATH=$LOW_CODE_DEPENDENCIES_PATH/matter-one

RUN set -x \
    && echo "source $IDF_PATH/export.sh" >> /home/espressif/.bashrc \
    && echo "source $LOW_CODE_PATH/export.sh" >> /home/espressif/.bashrc \
    && : # last line
