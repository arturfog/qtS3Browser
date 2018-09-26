#!/bin/bash
#
# This script creates QT 5.10 debian package

# Build package
dpkg-buildpackage -rfakeroot -I.git
