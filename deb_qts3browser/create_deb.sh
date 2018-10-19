#!/bin/bash
#
# This script creates AWS S3 libs debian package

cleanup() {
rm -rf build/*
rm *.dsc
rm *.changes
}

mkdir -p build

cleanup

cd build
# copy debian directory
cp -vfr ../../{desktop-file,debian,qml,src,inc,icons,qml.qrc,s3Browser.pro} .

# Build package
dpkg-buildpackage -rfakeroot -I.git
cd ..

cleanup

mkdir -p build

cd build

cp -vfr ../../{desktop-file,debian,qml,src,inc,icons,qml.qrc,s3Browser.pro} .
/opt/Qt5.10/bin/qmake -o Makefile s3Browser.pro -spec linux-g++ CONFIG+=release
build-wrapper-linux-x86-64 --out-dir ../../bw-output make -j 2

cd ..

cleanup
