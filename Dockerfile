FROM ubuntu:20.10

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
      python \
      python3 \
      python3-pip \
      python3-setuptools \
      rsync \
      ssh \
      tar \
      vim \
      wget \
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

ARG ESP_IDF_REV=21ecef5c56e01d3cccf0648c869e3fa9248bf3d4

RUN \
     cd esp-idf \
  && git checkout ${ESP_IDF_REV} \
  && git submodule update --init --recursive \
  && ./install.sh

USER root
RUN echo /tmp/stderr{,.pub} | xargs -n 1 ln -sf /dev/stderr && yes | ssh-keygen -t ecdsa -b 521 -N '' -qf /tmp/stderr > /dev/null
RUN service ssh start && service ssh stop

CMD [ "/usr/sbin/sshd", "-D", "-o", "ListenAddress=0.0.0.0" ]
