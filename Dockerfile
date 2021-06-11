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
#   $ ./scripts/docker/build --android-api 30
#

ARG jdk=11

# Stage 1, build container
FROM openjdk:8-alpine3.9 AS Build
ENV ANDROID_SDK_ROOT /opt/android-sdk-linux
RUN apk add --no-cache wget unzip; \
    rm -rf /var/cache/apk/*
RUN wget --quiet https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O /tmp/tools.zip \
    mkdir -p ${ANDROID_SDK_ROOT}; \
    unzip -q /tmp/tools.zip -d ${ANDROID_SDK_ROOT}; \
    rm -v /tmp/tools.zip; \
    mkdir -p /root/.android/; \
    touch /root/.android/repositories.cfg; \
    yes | ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager "cmdline-tools;latest" >/dev/null

# Stage 2, distribution container
FROM openjdk:${jdk}-slim
ARG android_api=30
ARG android_build_tools=30.0.3
LABEL maintainer="Sascha Peilicke <sascha@peilicke.de"
LABEL description="Android SDK ${android_api} with build-tools ${android_build_tools} using JDK ${jdk}"
ENV ANDROID_SDK_ROOT /opt/android-sdk-linux
ENV PATH $PATH:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin
RUN apt-get update; \
	apt-get install -y --no-install-recommends \
		git \
		git-lfs \
		openssl
COPY --from=BUILD ${ANDROID_SDK_ROOT} ${ANDROID_SDK_ROOT}
RUN yes | sdkmanager --licenses >/dev/null; \
    sdkmanager \
        "build-tools;${android_build_tools}" \
        "platforms;android-${android_api}"; \
    sdkmanager --list | sed -e '/^$/q'; \
    java -version
