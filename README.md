# Android SDK OCI / Docker image

[![License](https://img.shields.io/github/license/saschpe/docker-android-sdk)](https://opensource.org/licenses/Apache-2.0)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/saschpe/docker-android-sdk/ci.yml?branch=main)](https://github.com/saschpe/docker-android-sdk/actions?query=branch%3Amain++)
[![Docker Pulls](https://img.shields.io/docker/pulls/saschpe/android-sdk)](https://hub.docker.com/r/saschpe/android-sdk)
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/saschpe/android-sdk)](https://hub.docker.com/r/saschpe/android-sdk)

Android SDK OCI container image with pre-installed build-tools based on the latest
command-line tools and JDK 11 or later.

## Android SDK and JDK support

The following JDK and Android SDK API level combinations are currently supported:

|    | 11.0 | 17.0 |
|----|------|------|
| 31 | ✅   | ✅   |
| 32 | ✅   | ✅   |
| 33 | ✅   | ✅   |
| 34 | ✅   | ✅   |

## Usage

Use like you would any other base image:

```Dockerfile
FROM saschpe/android-sdk
RUN sdkmanager --install emulator
```

## Building

These scripts simplify various tasks related to container building and
publishing:

```shell
./scripts/build --help
```

## License

    Copyright 2017 Sascha Peilicke

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
