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
