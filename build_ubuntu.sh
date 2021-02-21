#!/bin/bash
# TODO: add colors to printed statuses

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo ${machine}

if [ "${machine}" != "Linux" ]; then
  echo "Error. Please run script on Linux !"
  exit 1
fi

. /etc/lsb-release

# update
apt-get update

# add gpg key
apt-key add gpg/bintray.key

MACHINE_TYPE=`uname -m`

if [ ${MACHINE_TYPE} == 'x86_64' ]; then
  # install all packages
  apt-get install -y build-essential wget libcanberra-gtk-module libx11-xcb1 libx11-6 libxau6 libxdamage1 libxdmcp6 libxext6 libxfixes3 libxxf86vm1 libdouble-conversion1 libdrm2 libglapi-mesa libgraphite2-3 libharfbuzz0b libicu60 libpcre16-3 libproxy1v5 libxcb-dri2-0 libxcb-dri3-0  libxcb-glx0 libxcb-present0 libxcb-sync1 libxcb1 libxshmfence1 libssl1.1 zlib1g libcurl3 libkrb5-3 libgssapi3-heimdal libroken18-heimdal libgnutls30 libp11-kit0 libstdc++6 libgcc1 libdb5.3 libgl1-mesa-dev libgl1-mesa-glx libgles2-mesa-dev libegl1-mesa fakeroot devscripts dh-make fonts-dejavu-core

sudo apt install libcurl4
sudo apt install libxcb-icccm4-dev
sudo apt install libxcb-keysyms1
sudo apt install libxcb-render-util0
sudo apt install libxkbcommon-x11-0

  #
  wget "https://github.com/arturfog/qtS3Browser/releases/download/1.1.0-pre/amazon-s3-cpp-sdk_1.8.142_amd64.deb"
  dpkg -i amazon-s3-cpp-sdk_1.8.142_amd64.deb
  #
  wget "https://github.com/arturfog/qtS3Browser/releases/download/1.1.0-pre/qt-everywhere_5.15.0_amd64.deb"
  dpkg -i qt-everywhere_5.15.0_amd64.deb
fi

echo -n "Creating build directory ..."
mkdir qts3browser_build
cd qts3browser_build
echo "[ OK ]"

#qmake -o Makefile ../s3Browser.pro -spec linux-g++ CONFIG+=debug CONFIG+=qml_debug
qmake -o Makefile ../s3Browser.pro -spec linux-g++ CONFIG+=release
make -j2
