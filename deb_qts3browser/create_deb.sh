#!/bin/bash
#
# This script creates AWS S3 libs debian package

cleanup() {
rm -rf build/*
rm *.dsc
rm *.changes
}

ARCH="amd64"
if [ ! -z "$1" ]; then
  ARCH="$1"
fi

cleanup

mkdir -p build && cd build
cp -vfr ../../{desktop-file,debian,qml,src,translations,inc,icons,*.qrc,s3Browser.pro} .

# Build package
if [ "$ARCH" == "amd64" ]; then
  dpkg-buildpackage -us -b -rfakeroot -I.git
elif [ "$ARCH" == "armhf" ]; then
  dpkg-buildpackage -us -b -aarmhf -rfakeroot -I.git
  cp -vf debian/rulesarmhf debian/rules
else
  cp -vf debian/rules32 debian/rules
  cp -vf debian/control32 debian/control
  dpkg-buildpackage -ai386 -I.git
fi

cd ..

cleanup

# build for sonarcloud
if [ "$ARCH" == "amd64" ]; then
  mkdir -p build && cd build
  cp -vfr ../../{desktop-file,debian,qml,src,translations,inc,icons,*.qrc,s3Browser.pro} .

  /opt/Qt5.15.0/bin/qmake -o Makefile s3Browser.pro -spec linux-g++ CONFIG+=release

  #wget 'https://sonarqube.com/static/cpp/build-wrapper-linux-x86.zip'
  #unzip build-wrapper-linux-x86.zip
  #export PATH=$PATH:$PWD/build-wrapper-linux-x86

  #build-wrapper-linux-x86-64 --out-dir /home/travis/build/arturfog/qtS3Browser/bw_output make -j 2
  cd ..
fi
