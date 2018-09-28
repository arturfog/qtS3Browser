#!/bin/bash
#
# This script creates QT 5.9.6 debian package

cleanup() {
rm *.tar.gz
rm *.dsc
rm *.changes
rm -rf qt-everywhere-5.9.6
}

cleanup

./checkout.sh

# copy debian directory
cp -vfr debian qt-everywhere-5.9.6
cd qt-everywhere-5.9.6

# Build package
dpkg-buildpackage -rfakeroot -I.git

cd ..

cleanup
