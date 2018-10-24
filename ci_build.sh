#!/bin/bash
# TODO: add return value checking
# TODO: add colors to printed statuses

# update
apt-get update

# install all packages
apt-get install -y build-essential wget libcanberra-gtk-module libx11-xcb1 libx11-6 libxau6 libxdamage1 libxdmcp6 libxext6 libxfixes3 libxxf86vm1 libdouble-conversion1v5 libdrm2 libglapi-mesa libgraphite2-3 libharfbuzz0b libicu55 libpcre16-3 libproxy1v5 libxcb-dri2-0 libxcb-dri3-0  libxcb-glx0 libxcb-present0 libxcb-sync1 libxcb1 libxshmfence1 libssl1.0.0 zlib1g libcurl3 libkrb5-3 libgssapi3-heimdal libroken18-heimdal libgnutls30 libp11-kit0 libstdc++6 libgcc1 libdb5.3 libgl1-mesa-dev libgl1-mesa-glx libgles2-mesa-dev libegl1-mesa fakeroot devscripts dh-make fonts-dejavu-core

# add gpg key
apt-key add gpg/bintray.key

###################
#                 #
#      amd64      #
#                 #
###################
wget "https://dl.bintray.com/arturfog/oss-arturfog/qt-everywhere_5.10.0_amd64.deb"
wget "https://dl.bintray.com/arturfog/oss-arturfog/amazon-s3-cpp-sdk_1.6.0_amd64.deb"
dpkg -i amazon-s3-cpp-sdk_1.6.0_amd64.deb
dpkg -i qt-everywhere_5.10.0_amd64.deb

cd deb_qts3browser
./create_deb.sh "amd64"

# remove amd64 versions of packages
apt remove -y amazon-s3-cpp-sdk
apt remove -y qt-everywhere
apt remove -y libgl1-mesa-dev libgl1-mesa-glx libgles2-mesa-dev libegl1-mesa fakeroot

##################
#                #
#      i386      #
#                #
##################
# add architecture
dpkg --add-architecture i386
if [ "$?" == "0" ]; then
  apt-get update
  
  apt-get install -y libssl1.0.0:i386 gcc-multilib g++-multilib libgl1-mesa-dev:i386 libgl1-mesa-glx:i386 zlib1g:i386 libcurl3:i386 libkrb5-3:i386 libgssapi3-heimdal:i386 libroken18-heimdal:i386 libgnutls30:i386 libp11-kit0:i386 libstdc++6:i386 libgcc1:i386 libdb5.3:i386 libxcb-glx0:i386 libxcb-present0:i386 libxcb-sync1:i386 libxcb1:i386 libicu55:i386 libkrb5-3:i386 libgssapi3-heimdal:i386 libroken18-heimdal:i386 libpng12-0:i386 libglib2.0-0:i386 fakeroot:i386

  ln -sf /usr/bin/x86_64-linux-gnu-strip /usr/bin/i686-linux-gnu-strip

  wget "https://dl.bintray.com/arturfog/oss-arturfog/pool/main/a/amazon-s3-cpp-sdk/amazon-s3-cpp-sdk_1.6.0_i386.deb"
  wget "https://dl.bintray.com/arturfog/oss-arturfog/pool/main/q/qt-everywhere/qt-everywhere_5.10.0_i386.deb"
  dpkg -i qt-everywhere_5.10.0_i386.deb
  dpkg -i amazon-s3-cpp-sdk_1.6.0_i386.deb

  #cd deb_qts3browser
  ./create_deb.sh "i386"
fi
