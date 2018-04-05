FROM openjdk:8-alpine
LABEL maintainer="Sascha Peilicke <sascha@peilicke.de"

ARG android_api=27
ARG android_build_tools=27.0.3

LABEL description="Android SDK ${android_api}"

ENV ANDROID_SDK_ROOT /opt/android-sdk-linux
ENV ANDROID_HOME $ANDROID_SDK_ROOT
ENV GLIBC 2.25-r0
ENV PATH $PATH:$ANDROID_SDK_ROOT/tools/bin

RUN apk add --no-cache --virtual=.build-dependencies wget unzip \
	&& wget https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub -O /etc/apk/keys/sgerrand.rsa.pub \
	&& wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC}/glibc-${GLIBC}.apk -O /tmp/glibc.apk \
	&& wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC}/glibc-bin-${GLIBC}.apk -O /tmp/glibc-bin.apk \
	&& apk add --no-cache /tmp/glibc.apk /tmp/glibc-bin.apk \
	&& rm -rf /tmp/* /var/cache/apk/*
RUN wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip -O /tmp/tools.zip \
	&& mkdir -p $ANDROID_SDK_ROOT \
    && unzip /tmp/tools.zip -d $ANDROID_SDK_ROOT \
    && rm -v /tmp/tools.zip
RUN yes | sdkmanager --licenses \
	&& mkdir -p /root/.android/ \
	&& touch /root/.android/repositories.cfg \
    && sdkmanager \
        "build-tools;${android_build_tools}" \
        "platforms;android-${android_api}" \
    && rm -rf  \
        # Delete proguard docs and examples
        $ANDROID_SDK_ROOT/tools/proguard/examples \
        $ANDROID_SDK_ROOT/tools/proguard/docs \
    && sdkmanager --list | sed -e '/Available Packages/q'

