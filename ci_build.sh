#!/bin/bash
# TODO: add return value checking
# TODO: add colors to printed statuses

# add gpg key
wget -qO - 'https://bintray.com/user/downloadSubjectPublicKey?username=arturfog' | apt-key add -

# add repo
echo "deb https://dl.bintray.com/arturfog/deb xenial main" | tee -a /etc/apt/sources.list 

if [ "$?" == "0" ]; then
# update
  apt-get update
else
  exit
fi

if [ "$?" == "0" ]; then
  # Installing generated AWS deb
  apt-get install -y --allow-unauthenticated amazon-s3-cpp-sdk
else
  exit
fi

if [ "$?" == "0" ]; then
  # Installing genereated QT deb
  apt-get install -y --allow-unauthenticated qt-everywhere
else
  exit
fi

if [ "$?" == "0" ]; then
  apt-get install -y build-essential
else
  exit
fi

if [ "$?" == "0" ]; then
  apt-get install -y libcanberra-gtk-module libx11-xcb1 libx11-6 libxau6 libxdamage1 libxdmcp6 libxext6 libxfixes3 libxxf86vm1 libdouble-conversion1v5 libdrm2 libglapi-mesa libgraphite2-3 libharfbuzz0b libicu55 libpcre16-3 libproxy1v5 libxcb-dri2-0 libxcb-dri3-0  libxcb-glx0 libxcb-present0  libxcb-sync1 libxcb1 libxshmfence1
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
