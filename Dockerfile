FROM ubuntu:20.10

ARG ESP_IDF_REV=a92185263e983a40a9d74df0e03e2c7228df0fa6 

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

RUN \
     cd esp-idf \
  && git checkout ${ESP_IDF_REV} \
  && git submodule update --init --recursive \
  && ./install.sh

USER root
RUN echo /tmp/stderr{,.pub} | xargs -n 1 ln -sf /dev/stderr && yes | ssh-keygen -t ecdsa -b 521 -N '' -qf /tmp/stderr > /dev/null
RUN service ssh start && service ssh stop

CMD [ "/usr/sbin/sshd", "-D", "-o", "ListenAddress=0.0.0.0" ]