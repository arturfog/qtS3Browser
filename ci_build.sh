#!/bin/bash
# TODO: add return value checking
# TODO: add colors to printed statuses

# update
apt-get update

# apt-get install libx11-xcb-dev libxcb-composite0-dev libxcb-cursor-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-dri2-0-dev libxcb-dri3-dev libxcb-glx0-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-keysyms1-dev libxcb-present-dev libxcb-randr0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-shape0-dev libxcb-shm0-dev libxcb-sync-dev libxcb-util-dev libxcb-xfixes0-dev libxcb-xinerama0-dev libxcb-xkb-dev libxcb-xtest0-dev libxcb1-dev

# sudo apt-get install libglu1-mesa-dev freeglut3-dev mesa-common-dev

# install all packages
apt-get install -y build-essential wget libcanberra-gtk-module libx11-xcb1 libx11-6 libxau6 libxdamage1 libxdmcp6 libxext6 libxfixes3 libxxf86vm1 libdouble-conversion1 libdrm2 libglapi-mesa libgraphite2-3 libharfbuzz0b libicu60 libpcre16-3 libproxy1v5 libxcb-dri2-0 libxcb-dri3-0  libxcb-glx0 libxcb-present0 libxcb-sync1 libxcb1 libxshmfence1 libssl1.1 zlib1g libcurl4 libkrb5-3 libgssapi3-heimdal libroken18-heimdal libgnutls30 libp11-kit0 libstdc++6 libgcc1 libdb5.3 libgl1-mesa-dev libgl1-mesa-glx libgles2-mesa-dev libegl1-mesa fakeroot devscripts dh-make fonts-dejavu-core

# add gpg key
apt-key add gpg/bintray.key

###################
#                 #
#      amd64      #
#                 #
###################
wget "https://dl.bintray.com/arturfog/oss-arturfog/pool/main/q/qt-everywhere/qt-everywhere_5.15.0_amd64.deb"
wget "https://dl.bintray.com/arturfog/oss-arturfog/pool/main/a/amazon-s3-cpp-sdk/amazon-s3-cpp-sdk_1.8.29_amd64.deb"
dpkg -i amazon-s3-cpp-sdk_1.8.29_amd64.deb
dpkg -i qt-everywhere_5.15.0_amd64.deb

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
echo "Build for i386"
dpkg --add-architecture i386
if [ "$?" == "0" ]; then
  apt-get update

  apt-get install -y libssl1.1:i386 gcc-multilib g++-multilib libgl1-mesa-dev:i386 libgl1-mesa-glx:i386 zlib1g:i386 libcurl3:i386 libkrb5-3:i386 libgssapi3-heimdal:i386 libroken18-heimdal:i386 libgnutls30:i386 libp11-kit0:i386 libstdc++6:i386 libgcc1:i386 libdb5.3:i386 libxcb-glx0:i386 libxcb-present0:i386 libxcb-sync1:i386 libxcb1:i386 libkrb5-3:i386 libgssapi3-heimdal:i386 libroken18-heimdal:i386 libglib2.0-0:i386 fakeroot:i386 libpng16-16:i386

  wget "http://ftp.us.debian.org/debian/pool/main/i/icu/libicu57_57.1-6+deb9u4_i386.deb"
  dpkg -i "libicu57_57.1-6+deb9u4_i386.deb"
  ln -sf /usr/bin/x86_64-linux-gnu-strip /usr/bin/i686-linux-gnu-strip

  wget "https://dl.bintray.com/arturfog/oss-arturfog/pool/main/a/amazon-s3-cpp-sdk/amazon-s3-cpp-sdk_1.8.29_i386.deb"
  wget "https://dl.bintray.com/arturfog/oss-arturfog/pool/main/q/qt-everywhere/qt-everywhere_5.15.0_i386.deb"
  dpkg -i --force-depends qt-everywhere_5.15.0_i386.deb
  dpkg -i --force-depends amazon-s3-cpp-sdk_1.8.29_i386.deb

  #cd deb_qts3browser
  ./create_deb.sh "i386"
  echo "Done"
fi
