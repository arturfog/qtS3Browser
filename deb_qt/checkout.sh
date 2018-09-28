#!/bin/bash

# download
if [ ! -e "qt-everywhere-opensource-src-5.9.6.tar.xz" ]; then
  echo "Downloading sources ..."
  wget https://download.qt.io/archive/qt/5.9/5.9.6/single/qt-everywhere-opensource-src-5.9.6.tar.xz
fi
echo "Downloaded sources ..."

# unpack
if [ ! -d "qt-everywhere-5.9.6" ]; then
  echo "Unpacking sources ..."
  tar -xf qt-everywhere-opensource-src-5.9.6.tar.xz
  mv qt-everywhere-opensource-src-5.9.6 qt-everywhere-5.9.6
fi

echo "Sources unpacked ..."
