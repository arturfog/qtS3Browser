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

# add gpg key
sudo apt-key add gpg/bintray.key

# add repo
echo "deb https://dl.bintray.com/arturfog/deb stretch main" | tee -a /etc/apt/sources.list 

if [ "$?" == "0" ]; then
# update
  sudo apt-get update
else
  exit
fi

# install all packages
apt-get install -y build-essential wget libcanberra-gtk-module libx11-xcb1 libx11-6 libxau6 libxdamage1 libxdmcp6 libxext6 libxfixes3 libxxf86vm1 libdouble-conversion1v5 libdrm2 libglapi-mesa libgraphite2-3 libharfbuzz0b libicu55 libpcre16-3 libproxy1v5 libxcb-dri2-0 libxcb-dri3-0  libxcb-glx0 libxcb-present0 libxcb-sync1 libxcb1 libxshmfence1 libssl1.0.0 zlib1g libcurl3 libkrb5-3 libgssapi3-heimdal libroken18-heimdal libgnutls30 libp11-kit0 libstdc++6 libgcc1 libdb5.3 libgl1-mesa-dev libgl1-mesa-glx libgles2-mesa-dev libegl1-mesa fakeroot devscripts dh-make fonts-dejavu-core


if [ "$?" == "0" ]; then
  # Installing generated AWS deb
  sudo apt-get install -y amazon-s3-cpp-sdk
else
  exit
fi

if [ "$?" == "0" ]; then
  # Installing genereated QT deb
  sudo apt-get install -y qt-everywhere
else
  exit
fi

if [ "$?" == "0" ]; then
  sudo apt-get install -y libcanberra-gtk-module libx11-xcb1 libx11-6 libxau6 libxdamage1 libxdmcp6 libxext6 libxfixes3 libxxf86vm1 libdouble-conversion1v5 libdrm2 libglapi-mesa libgraphite2-3 libharfbuzz0b libicu55 libpcre16-3 libproxy1v5 libxcb-dri2-0 libxcb-dri3-0  libxcb-glx0 libxcb-present0  libxcb-sync1 libxcb1 libxshmfence1
else
  exit
fi

echo -n "Creating build directory ..."
mkdir qts3browser_build
cd qts3browser_build
echo "[ OK ]"

#qmake -o Makefile ../s3Browser.pro -spec linux-g++ CONFIG+=debug CONFIG+=qml_debug
qmake -o Makefile ../s3Browser.pro -spec linux-g++ CONFIG+=release
make -j2
