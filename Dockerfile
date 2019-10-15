FROM ubuntu:18.04
LABEL maintainer="Charles R. Portwood II <charlesportwoodii@erianna.com>"

ENV GNU_INSTALL_ROOT="/root/gcc-arm-none-eabi-8-2019-q3-update/bin/"
ENV NORDIC_SDK_PATH="/root/nrf_sdk/15.3.0"
ENV PATH="$PATH:/root/gcc-arm-none-eabi-8-2019-q3-update/bin:/root/mergehex:/root/nrfjprog:/root/.local/bin"

ENV BOARD=""
ENV DEBUG=0
ENV NRF_DFU_BL_ACCEPT_SAME_VERSION=1
ENV NRF_DFU_REQUIRE_SIGNED_APP_UPDATE=1
ENV NRF_BL_APP_SIGNATURE_CHECK_REQUIRED=0

VOLUME [ "/app" ]

# Copy the TravisCI setup script for running
COPY .travis/before_install.sh /tmp/before_install.sh

# Install apt dependencies
RUN apt update -qq && \
    apt install git unzip wget curl make build-essential dos2unix python python-pip -y && \
    apt-get clean

# Install nrf52 SDK
RUN chmod +x /tmp/before_install.sh && \
    ./tmp/before_install.sh && \
    pip install --user nrfutil

WORKDIR /app

CMD ["make", "clean_build"]