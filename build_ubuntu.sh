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
  #
  wget "https://bintray.com/api/ui/download/arturfog/oss-arturfog/pool/main/a/amazon-s3-cpp-sdk/amazon-s3-cpp-sdk_1.8.29_amd64.deb"
  dpkg -i amazon-s3-cpp-sdk_1.8.29_amd64.deb
  #
  wget "https://bintray.com/api/ui/download/arturfog/oss-arturfog/pool/main/q/qt-everywhere/qt-everywhere_5.15.0_amd64.deb"
  dpkg -i qt-everywhere_5.15.0_amd64.deb
else
  apt-get install -y build-essential wget libcanberra-gtk-module libx11-xcb1 libx11-6 libxau6 libxdamage1 libxdmcp6 libxext6 libxfixes3 libxxf86vm1 libdouble-conversion1 libdrm2 libglapi-mesa libgraphite2-3 libssl1.0.0:i386  libgl1-mesa-dev:i386 libgl1-mesa-glx:i386 zlib1g:i386 libcurl3:i386 libkrb5-3:i386 libgssapi3-heimdal:i386 libroken18-heimdal:i386 libgnutls30:i386 libp11-kit0:i386 libstdc++6:i386 libgcc1:i386 libdb5.3:i386 libxcb-glx0:i386 libxcb-present0:i386 libxcb-sync1:i386
  libxcb1:i386 libicu60:i386 libkrb5-3:i386 libgssapi3-heimdal:i386 libroken18-heimdal:i386 libpng12-0:i386 libglib2.0-0:i386 fakeroot:i386 devscripts dh-make fonts-dejavu-core
  #
  wget "https://bintray.com/api/ui/download/arturfog/oss-arturfog/pool/main/a/amazon-s3-cpp-sdk/amazon-s3-cpp-sdk_1.8.29_i386.deb"
  dpkg -i amazon-s3-cpp-sdk_1.8.29_i386.deb
  #
  wget "https://bintray.com/api/ui/download/arturfog/oss-arturfog/pool/main/q/qt-everywhere/qt-everywhere_5.15.0_i386.deb"
  dpkg -i qt-everywhere_5.15.0_i386.deb
fi

echo -n "Creating build directory ..."
mkdir qts3browser_build
cd qts3browser_build
echo "[ OK ]"

qmake -o Makefile ../s3Browser.pro -spec linux-g++ CONFIG+=debug CONFIG+=qml_debug
#qmake -o Makefile ../s3Browser.pro -spec linux-g++ CONFIG+=release
make -j2
