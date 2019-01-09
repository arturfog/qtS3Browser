#!/bin/bash
#sudo dpkg --add-architecture i386; sudo apt-get update; sudo apt-get install libssl1.0.0:i386

sudo apt-get install mesa-common-dev libglu1-mesa-dev libdbus-1-dev libfreetype6-dev libicu-dev libinput-dev libxkbcommon-dev libsqlite3-dev libpng-dev libjpeg-dev libglib2.0-dev libxkbcommon-x11-dev libfontconfig1-dev debhelper git build-essential openssl libssl-dev

./configure -opensource -confirm-license -release -ssl -platform linux-g++-32 -skip qtwayland -skip qtwebengine -skip qtscript -nomake examples -prefix /opt/Qt5.11.3

make -j 10

