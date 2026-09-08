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
#   $ ./scripts/build --android 34 --jdk 25.0.4_7
#

ARG jdk=25.0.4_7

FROM eclipse-temurin:${jdk}-jdk
ARG android=37.2
ARG jdk
LABEL maintainer="Sascha Peilicke <sascha@peilicke.de>"
LABEL description="Android SDK ${android} using JDK ${jdk}"

ENV ANDROID_SDK_ROOT=/opt/android-sdk-linux
ENV PATH=$PATH:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/emulator

RUN apt-get update && apt-get install -y --no-install-recommends curl git gnupg openssl unzip \
 && curl -s https://dl.google.com/android/repository/commandlinetools-linux-15859902_latest.zip -o /tmp/tools.zip \
 && unzip -q /tmp/tools.zip -d /tmp \
 && /tmp/cmdline-tools/bin/android --sdk="${ANDROID_SDK_ROOT}" sdk install cmdline-tools/latest \
 && rm -rf /tmp/tools.zip /tmp/cmdline-tools /var/lib/apt/lists/* \
 && adduser nonroot && chown nonroot:nonroot -R "${ANDROID_SDK_ROOT}"
USER nonroot
RUN mkdir -p /home/nonroot/.android/ && touch /home/nonroot/.android/repositories.cfg \
 && android sdk install platform-tools platforms/android-${android}
