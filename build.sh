#!/bin/bash
# TODO: add return value checking
# TODO: add colors to printed statuses

# add gpg key
wget -qO - 'https://bintray.com/user/downloadSubjectPublicKey?username=arturfog' | sudo apt-key add -

# add repo
echo "deb https://dl.bintray.com/arturfog/deb xenial main" | sudo tee -a /etc/apt/sources.list 

# update
sudo apt-get update

# Installing generated AWS deb
sudo apt-get install amazon-s3-cpp-sdk

# Installing genereated QT deb
sudo apt-get install qt-everywhere

echo -n "Creating build directory ..."
mkdir ../qts3browser_build
cd ../qts3browser_build
echo "[ OK ]"

qmake -o Makefile ../qtS3Browser/s3Browser.pro -spec linux-g++ CONFIG+=debug CONFIG+=qml_debug
