#
# Android SDK container image with build-tools.
#
# Contains JDK, Android SDK and Android Build Tools. Each version is
# configurable. Build and publish with default arguments:
#
#   $ ./scripts/build --push
#
# Build with custom arguments:
#
#   $ ./scripts/build --android 33 --jdk 17.0.6_10
#

ARG jdk=17.0.6_10

FROM eclipse-temurin:${jdk}-jdk
ARG android=33
LABEL maintainer="Sascha Peilicke <sascha@peilicke.de"
LABEL description="Android SDK ${android} using JDK ${jdk}"

ENV ANDROID_SDK_ROOT /opt/android-sdk-linux
ENV PATH $PATH:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/emulator

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        git-lfs \
        gnupg \
        openssl \
        unzip \
        wget
RUN wget --quiet  https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O /tmp/tools.zip && \
    unzip -q /tmp/tools.zip -d /tmp && \
    yes | /tmp/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses && \
    /tmp/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "cmdline-tools;latest" && \
    rm -r /tmp/tools.zip /tmp/cmdline-tools && \
    mkdir -p /root/.android/ && touch /root/.android/repositories.cfg \
    apt-get remove wget unzip && apt-get autoremove && apt-get autoclean
RUN yes | sdkmanager --licenses && \
    sdkmanager --update && \
    sdkmanager --install \
        "platforms;android-${android}" \
        "platform-tools"
