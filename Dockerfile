#
# Android SDK container image with build-tools.
#
# Contains JDK, Android SDK and Android Build Tools. Each version is
# configurable. Build and publish with default arguments:
#
#   $ ./scripts/docker/build --docker-push
#
# Build with custom arguments:
#
#   $ ./scripts/docker/build --android-api 31
#

ARG jdk=11.0.15_10

FROM eclipse-temurin:${jdk}-jdk
ARG android_api=32
LABEL maintainer="Sascha Peilicke <sascha@peilicke.de"
LABEL description="Android SDK ${android_api} using JDK ${jdk}"

ENV ANDROID_SDK_ROOT /opt/android-sdk-linux
ENV PATH $PATH:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        git-lfs \
        openssl \
        wget \
        unzip
RUN wget --quiet  https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip -O /tmp/tools.zip && \
    mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    unzip -q /tmp/tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm -v /tmp/tools.zip && \
    mkdir -p /root/.android/ && touch /root/.android/repositories.cfg \
    apt-get remove wget unzip && apt-get autoremove && apt-get autoclean
RUN yes | sdkmanager --licenses && \
    sdkmanager --update && \
    sdkmanager --install \
        "platforms;android-${android_api}" \
        platform-tools
