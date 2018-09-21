# qtS3Browser

[![Snap Status](https://build.snapcraft.io/badge/arturfog/qtS3Browser.svg)](https://build.snapcraft.io/user/arturfog/qtS3Browser)

[![Travis Status](https://travis-ci.org/arturfog/qtS3Browser.svg?branch=master)](https://travis-ci.org/arturfog/qtS3Browser#)

Simple **Amazon S3** client written in C++/QT

![Main Window](https://github.com/arturfog/qtS3Browser/raw/master/assets/app_main.png)

## Testing:

It's recommended to use S3rver (https://github.com/jamhall/s3rver)

## Build:

`unfortunately this process is not yet fully ready`

- use build.sh script
```sh
  ./build.sh
```

OR follow steps below

- pull sources
- install conan.io
```sh
  sudo pip3 install conan
```
- add my conan repo 
```sh
  conan remote add arturfog-conan-repo https://api.bintray.com/conan/arturfog/oss-conan 
```
- invoke conan install
```sh
  conan install aws-sdk-cpp/1.4.64@arturfog/release -o aws-sdk-cpp:build_s3=True -o aws-sdk-cpp:build_transfer=True -o min_size=False -o aws-sdk-cpp:shared=True -s os=Linux -s arch=x86_64 -s build_type=Release
```
- open project in QtCreator and build (or use qmake)

## Installation

Application will be released as snap package
```sh
snap install qts3browser
```
**TODO**
