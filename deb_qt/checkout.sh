#!/bin/bash

VERSION="5.11.3"
# download
if [ ! -e "qt-everywhere-src-${VERSION}.tar.xz" ]; then
  echo "Downloading sources ..."
  wget https://download.qt.io/archive/qt/5.11/${VERSION}/single/qt-everywhere-src-${VERSION}.tar.xz
fi
echo "Downloaded sources ..."

# unpack
if [ ! -d "qt-everywhere-${VERSION}" ]; then
  echo "Unpacking sources ..."
  tar -xf qt-everywhere-src-${VERSION}.tar.xz
  mv qt-everywhere-src-${VERSION} qt-everywhere-${VERSION}
fi

echo "Sources unpacked ..."
