FROM ubuntu:23.10

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN apt-get update -qqy && \
    apt-get install -qqy \
      bison \
      build-essential \
      ccache \
      cmake \
      curl \
      dfu-util \
      flex \
      git \
      gperf \
      libffi-dev \
      libssl-dev \
      libusb-1.0-0 \
      ninja-build \
      python3 \
      python3-pip \
      python3-setuptools \
      python3.11-venv \
      tar \
      wget \
      zip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN \
  useradd -m builder \
  && usermod -s /bin/bash builder \
  && echo 'builder:builder' | chpasswd

USER builder

WORKDIR /home/builder

COPY bashrc .bashrc

RUN \
     git clone https://github.com/espressif/esp-idf.git

ARG ESP_IDF_REF

RUN \
     echo "ESP_IDF_REF=${ESP_IDF_REF}" \
  && cd esp-idf \
  && git checkout ${ESP_IDF_REF} \
  && git submodule update --init --recursive \
  && ./install.sh

# Fix hanging script on login
RUN \
  sed -i 's/^enable_autocomplete$//' /home/builder/esp-idf/export.sh

USER root

# Force /bin/sh to be /bin/bash
# See https://gitlab.com/gitlab-org/gitlab-runner/-/issues/27614
RUN \
  ln -snf /bin/bash /bin/sh

USER builder
