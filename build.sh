#!/bin/bash
# TODO: add return value checking
# TODO: add colors to printed statuses

echo -n "Installing conan ..."
sudo pip3 -U install conan
echo "[ OK ]"

echo -n "Adding repository with aws ..."
conan remote add arturfog-conan-repo https://api.bintray.com/conan/arturfog/oss-conan
echo "[ OK ]"

echo -n "Generating conanbuildinfo.pri ..."
conan install .
echo "[ OK ]"

echo -n "Creating build directory ..."
mkdir ../qts3browser_build
cd ../qts3browser_build
echo "[ OK ]"

qmake -o Makefile ../qtS3Browser/s3Browser.pro -spec linux-g++ CONFIG+=debug CONFIG+=qml_debug
