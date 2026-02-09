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
#   $ ./scripts/build --android 34 --jdk 23.0.2_7
#

ARG jdk=25.0.2_10

FROM eclipse-temurin:${jdk}-jdk
ARG android=36
ARG jdk
LABEL maintainer="Sascha Peilicke <sascha@peilicke.de"
LABEL description="Android SDK ${android} using JDK ${jdk}"

ENV ANDROID_SDK_ROOT=/opt/android-sdk-linux
ENV PATH=$PATH:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/emulator

RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        git \
        gnupg \
        openssl \
        unzip
RUN curl -s https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -o /tmp/tools.zip && \
    unzip -q /tmp/tools.zip -d /tmp && \
    yes | /tmp/cmdline-tools/bin/sdkmanager --sdk_root="${ANDROID_SDK_ROOT}" --licenses && \
    /tmp/cmdline-tools/bin/sdkmanager --sdk_root="${ANDROID_SDK_ROOT}" --install "cmdline-tools;latest" && \
    rm -r /tmp/tools.zip /tmp/cmdline-tools
RUN adduser nonroot && chown nonroot:nonroot -R "${ANDROID_SDK_ROOT}"
USER nonroot
RUN mkdir -p /home/nonroot/.android/ && touch /home/nonroot/.android/repositories.cfg
RUN yes | sdkmanager --licenses >/dev/null && sdkmanager --install \
        "platforms;android-${android}" \
        "platform-tools"
