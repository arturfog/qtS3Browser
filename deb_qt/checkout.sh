#!/bin/bash

# download
if [ ! -e "qt-everywhere-src-5.10.0.tar.xz" ]; then
  echo "Downloading sources ..."
  wget https://download.qt.io/archive/qt/5.10/5.10.0/single/qt-everywhere-src-5.10.0.tar.xz
fi
echo "Downloaded sources ..."

# unpack
if [ ! -d "qt-everywhere-5.10.0" ]; then
  echo "Unpacking sources ..."
  tar -xf qt-everywhere-src-5.10.0.tar.xz
  mv qt-everywhere-src-5.10.0 qt-everywhere-5.10.0
fi

echo "Sources unpacked ..."
