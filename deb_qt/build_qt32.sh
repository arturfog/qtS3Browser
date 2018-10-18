#!/bin/bash
sudo dpkg --add-architecture i386; sudo apt-get update; sudo apt-get install libssl1.0.0:i386

./configure -opensource -confirm-license -release -ssl -platform linux-g++-32 -skip qtwayland -skip qtwebengine -skip qtscript -nomake examples -prefix /opt/Qt5.10

make -j 10

