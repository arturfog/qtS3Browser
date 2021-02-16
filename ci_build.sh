#!/bin/bash
# TODO: add return value checking
# TODO: add colors to printed statuses

# update
apt-get update

# install all packages
apt-get install -y build-essential wget libcanberra-gtk-module libx11-xcb1 libx11-6 libxau6 libxdamage1 libxdmcp6 libxext6 libxfixes3 libxxf86vm1 libdouble-conversion1 libdrm2 libglapi-mesa libgraphite2-3 libharfbuzz0b libicu60 libpcre16-3 libproxy1v5 libxcb-dri2-0 libxcb-dri3-0  libxcb-glx0 libxcb-present0 libxcb-sync1 libxcb1 libxshmfence1 libssl1.1 zlib1g libcurl4 libkrb5-3 libgssapi3-heimdal libroken18-heimdal libgnutls30 libp11-kit0 libstdc++6 libgcc1 libdb5.3 libgl1-mesa-dev libgl1-mesa-glx libgles2-mesa-dev libegl1-mesa fakeroot devscripts dh-make fonts-dejavu-core

# add gpg key
apt-key add gpg/bintray.key

###################
#                 #
#      amd64      #
#                 #
###################
wget "https://github.com/arturfog/qtS3Browser/releases/download/1.1.0-pre/qt-everywhere_5.15.0_amd64.deb"
wget "https://github.com/arturfog/qtS3Browser/releases/download/1.1.0-pre/amazon-s3-cpp-sdk_1.8.142_amd64.deb"
dpkg -i amazon-s3-cpp-sdk_1.8.142_amd64.deb
dpkg -i qt-everywhere_5.15.0_amd64.deb

cd deb_qts3browser
./create_deb.sh "amd64"
