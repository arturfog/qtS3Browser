#!/bin/bash
# TODO: add return value checking
# TODO: add colors to printed statuses

apt-get update && apt-get install -y apt-transport-https wget

# add gpg key
apt-key add gpg/arturfog.key

# add repo
echo "deb https://dl.bintray.com/arturfog/deb xenial main" | tee -a /etc/apt/sources.list 

# Installing generated AWS deb

apt-get install -y --allow-unauthenticated amazon-s3-cpp-sdk && apt-get install -y --allow-unauthenticated qt-everywhere

apt-get install -y build-essential

apt-get install -y libcanberra-gtk-module libx11-xcb1 libx11-6 libxau6 libxdamage1 libxdmcp6 libxext6 libxfixes3 libxxf86vm1 libdouble-conversion1v5 libdrm2 libglapi-mesa libgraphite2-3 libharfbuzz0b libicu55 libpcre16-3 libproxy1v5 libxcb-dri2-0 libxcb-dri3-0  libxcb-glx0 libxcb-present0  libxcb-sync1 libxcb1 libxshmfence1

echo -n "Creating build directory ..."
mkdir qts3browser_build
cd qts3browser_build
echo "[ OK ]"

#qmake -o Makefile ../s3Browser.pro -spec linux-g++ CONFIG+=debug CONFIG+=qml_debug
qmake -o Makefile ../s3Browser.pro -spec linux-g++ CONFIG+=release
make -j2
