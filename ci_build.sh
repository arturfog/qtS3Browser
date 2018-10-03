#!/bin/bash
# TODO: add return value checking
# TODO: add colors to printed statuses

apt-get update

# add gpg key
apt-key add gpg/arturfog.key

apt-get install -y build-essential wget libcanberra-gtk-module libx11-xcb1 libx11-6 libxau6 libxdamage1 libxdmcp6 libxext6 libxfixes3 libxxf86vm1 libdouble-conversion1v5 libdrm2 libglapi-mesa libgraphite2-3 libharfbuzz0b libicu55 libpcre16-3 libproxy1v5 libxcb-dri2-0 libxcb-dri3-0  libxcb-glx0 libxcb-present0 libxcb-sync1 libxcb1 libxshmfence1 libssl1.0.0 zlib1g libcurl3 libkrb5-3 libgssapi3-heimdal libroken18-heimdal libgnutls30 libp11-kit0 libstdc++6 libgcc1 libdb5.3 libgl1-mesa-dev libgl1-mesa-glx libgles2-mesa-dev libegl1-mesa


wget 'https://dl.bintray.com/arturfog/oss-arturfog/amazon-s3-cpp-sdk_1.6.0_amd64.deb'
dpkg -i amazon-s3-cpp-sdk_1.6.0_amd64.deb

wget 'https://dl.bintray.com/arturfog/oss-arturfog/qt-everywhere_5.10.0_amd64.deb'
dpkg -i qt-everywhere_5.10.0_amd64.deb

echo -n "Creating build directory ..."
mkdir qts3browser_build
cd qts3browser_build
echo "[ OK ]"

#qmake -o Makefile ../s3Browser.pro -spec linux-g++ CONFIG+=debug CONFIG+=qml_debug
/opt/Qt5.10/bin/qmake -o Makefile ../s3Browser.pro -spec linux-g++ CONFIG+=release
make -j2
