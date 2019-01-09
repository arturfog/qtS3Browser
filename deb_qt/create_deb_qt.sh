#!/bin/bash
#
# This script creates QT 5.9.6 debian package

cleanup() {
rm *.tar.gz
rm *.dsc
rm *.changes
#rm -rf qt-everywhere-5.11.3
}

cleanup

sudo apt install -y libinput-dev libsqlite3-dev libjpeg-dev libxkbcommon-x11-dev

#./checkout.sh

# copy debian directory
cp -vfr debian qt-everywhere-5.11.3
cd qt-everywhere-5.11.3

# Build package
dpkg-buildpackage -nc -rfakeroot -I.git

cd ..

cleanup
