#!/bin/bash
#
# This script creates QT 5.9.6 debian package
cp -vfr debian qt-everywhere-5.9.6
cd qt-everywhere-5.9.6
# Build package
dpkg-buildpackage -rfakeroot -I.git
