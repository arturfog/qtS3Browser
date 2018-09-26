#!/bin/bash
# TODO: add return value checking
# TODO: add colors to printed statuses

#echo -n "Installing conan ..."
#sudo pip3 -U install conan
#echo "[ OK ]"

#echo -n "Adding repository with aws ..."
#conan remote add arturfog-conan-repo https://api.bintray.com/conan/arturfog/oss-conan
#echo "[ OK ]"

#echo -n "Generating conanbuildinfo.pri ..."
#conan install . -s os=Linux -s arch=x86_64 -s build_type=Release -s compiler.version=7
#echo "[ OK ]"

# Installing generated AWS deb
sudo dpkg -i aws.deb
# Installing genereated QT deb
sudo dpkg -i qt510.deb

echo -n "Creating build directory ..."
mkdir ../qts3browser_build
cd ../qts3browser_build
echo "[ OK ]"

qmake -o Makefile ../qtS3Browser/s3Browser.pro -spec linux-g++ CONFIG+=debug CONFIG+=qml_debug
