#!/bin/bash
#
# This script creates QT 5.10.1 debian package
cp -vfr debian qt-everywhere-5.10.1
cd qt-everywhere-5.10.1
# Build package
dpkg-buildpackage -rfakeroot -I.git
