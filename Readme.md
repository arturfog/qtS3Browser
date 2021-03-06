# qtS3Browser


| Service | Status                                         |
| ------- | ---------------------------------------------- |
| Snap | [![qts3browser](https://snapcraft.io/qts3browser/badge.svg)](https://snapcraft.io/qts3browser) |
| Travis CI | [![Travis Status](https://travis-ci.com/arturfog/qtS3Browser.svg?branch=master)](https://travis-ci.com/github/arturfog/qtS3Browser) |
| Appveyor | [![Build status](https://ci.appveyor.com/api/projects/status/niv2eo6816w73tp9?svg=true)](https://ci.appveyor.com/project/arturfog/qts3browser) |
| Gitlab (mirror) | [![gitlab mirror](https://img.shields.io/badge/code%20mirror-gitlab-blue.svg)](https://gitlab.com/arturfog/qts3browser/commits/master) |
| SonarCloud | [![SonarCloud](https://sonarcloud.io/api/project_badges/measure?project=arturfog_qtS3Browser&metric=alert_status)](https://sonarcloud.io/dashboard?id=arturfog_qtS3Browser) |
| Gitter | [![Gitter](https://badges.gitter.im/arturfog/qtS3Browser.svg)](https://gitter.im/arturfog/qtS3Browser?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge) |

Simple **Amazon S3** client written in C++/QT

![Main Window](https://github.com/arturfog/qtS3Browser/raw/master/assets/app_main.png)

[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/qts3browser)

## Testing:

It's recommended to use S3rver (https://github.com/jamhall/s3rver)

## Build:

![ubuntu](https://github.com/arturfog/qtS3Browser/raw/master/assets/64_ubuntu_icon.png)
### Ubuntu
- use build_ubuntu.sh script

![osx](https://github.com/arturfog/qtS3Browser/raw/master/assets/64_osx_icon.png)
### MacOS X 
- use build_osx.sh script
#### To build qts3browser, following software is required
- Xcode command line tools
```sh
xcode-select --install
```
- brew - https://brew.sh/index
- Qt5 (can be installed using brew)
```sh
brew install qt5 2>&1 > /dev/null
brew link qt5 --force
```

![windows10](https://github.com/arturfog/qtS3Browser/raw/master/assets/64_win_icon.png)
### Windows 10
- use build_win10.bat script
#### To build qts3browser, following software is required
- Git for Windows - https://git-scm.com/download/win
- Qt 5.12 or newer - https://www.qt.io/offline-installers
- Visual Studio Community - https://visualstudio.microsoft.com/pl/vs/community/

## Installation

![ubuntu](https://github.com/arturfog/qts3browser/raw/master/assets/64_ubuntu_icon.png)![fedora](https://github.com/arturfog/qts3browser/raw/master/assets/64_fedora_icon.png)![arch](https://github.com/arturfog/qts3browser/raw/master/assets/64_arch_icon.png)![mint](https://github.com/arturfog/qts3browser/raw/master/assets/64_mint_icon.png)![rpi](https://github.com/arturfog/qts3browser/raw/master/assets/64_rpi_icon.png)

```sh
# note: application is still under active development (latest releases are available in experimental 'edge' channel)

snap install --edge qts3browser
```

![ubuntu](https://github.com/arturfog/qts3browser/raw/master/assets/64_ubuntu_icon.png)
### Ubuntu
install .deb packages from https://bintray.com/arturfog/oss-arturfog

```sh
# AMAZON S3 (1.8.141)
https://github.com/arturfog/qtS3Browser/releases/download/1.1.0-pre/amazon-s3-cpp-sdk_1.8.142_amd64.deb
# QT 5.15.0
https://github.com/arturfog/qtS3Browser/releases/download/1.1.0-pre/qt-everywhere_5.15.0_amd64.deb
# qts3browser
https://github.com/arturfog/qtS3Browser/releases/download/1.1.0-pre/qts3browser_1.1.0_amd64.deb
```

![rpi](https://github.com/arturfog/qts3browser/raw/master/assets/64_rpi_icon.png)
### Rasbian
install .deb packages from https://bintray.com/arturfog/oss-arturfog

```sh
# AMAZON S3 (1.8.29)
https://dl.bintray.com/arturfog/oss-arturfog/pool/main/a/amazon-s3-cpp-sdk/amazon-s3-cpp-sdk_1.8.29_armhf.deb
# QT 5.15.0
https://dl.bintray.com/arturfog/oss-arturfog/pool/main/q/qt-everywhere/qt-everywhere_5.15.0_armhf.deb
# qts3browser
https://dl.bintray.com/arturfog/oss-arturfog/pool/main/m/qts3browser/qts3browser_1.0.12_armhf.deb
```

![osx](https://github.com/arturfog/qtS3Browser/raw/master/assets/64_osx_icon.png)
### MacOS X (dmg)
Application will be released as .dmg file

#### First test versions generated by travis ci available are avaiable at:

https://bintray.com/arturfog/dmg-arturfog/qts3browser

![windows10](https://github.com/arturfog/qtS3Browser/raw/master/assets/64_win_icon.png)
### Windows
Application will be relased as standalone .zip and installer file

#### First test versions are generated by appveyor jobs:

https://ci.appveyor.com/project/arturfog/qts3browser/build/artifacts

# Support this project
- Star GitHub repository :star:
- Create pull requests, submit bugs or suggest new features
