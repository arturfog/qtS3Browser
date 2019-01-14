#!/bin/bash
#
# This script creates QT 5.9.6 debian package

# Raspberry compilation: http://www.tal.org/tutorials/building-qt-510-raspberry-pi-debian-stretch

cleanup() {
rm *.tar.gz
rm *.dsc
rm *.changes
#rm -rf qt-everywhere-5.11.3
}

cleanup

sudo apt-get install -y build-essential libfontconfig1-dev libdbus-1-dev libfreetype6-dev libicu-dev libinput-dev libxkbcommon-dev libsqlite3-dev libssl-dev libpng-dev libjpeg-dev libglib2.0-dev libraspberrypi-dev

#./checkout.sh

# copy debian directory
cp -vfr debian qt-everywhere-5.11.3
cd qt-everywhere-5.11.3

# Build package
dpkg-buildpackage -nc -us -b -rfakeroot -I.git

cd ..

cleanup
