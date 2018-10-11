#!/bin/bash
# Travis checkout dir
#
# /Users/travis/build/arturfog/qtS3Browser
brew install qt5 2>&1 > /dev/null
brew link qt5 --force

# AWS
cd deb_aws 

./build.sh

# deb aws
cd ..
# QTS3BROWSER
mkdir -p build
cd build

pwd

# copy AWS

mkdir -p aws
cp -vf ../deb_aws/aws-sdk-cpp/build/aws-cpp-sdk-core/*.dylib ./
cp -vf ../deb_aws/aws-sdk-cpp/build/aws-cpp-sdk-transfer/*.dylib ./
cp -vf ../deb_aws/aws-sdk-cpp/build/aws-cpp-sdk-s3/*.dylib ./

cp -vfr ../deb_aws/aws-sdk-cpp/aws-cpp-sdk-core/include/* ./
cp -vfr ../deb_aws/aws-sdk-cpp/aws-cpp-sdk-transfer/include/* ./
cp -vfr ../deb_aws/aws-sdk-cpp/aws-cpp-sdk-s3/include/* ./


/usr/local/opt/qt5/bin/qmake ../s3Browser.pro CONFIG+=release && make
/usr/local/opt/qt5/bin/macdeployqt s3browser.app -always-overwrite -verbose=2 -qmldir=../qml

curl -o /tmp/macdeployqtfix.py https://raw.githubusercontent.com/aurelien-rainone/macdeployqtfix/master/macdeployqtfix.py

python /tmp/macdeployqtfix.py ./s3browser.app/Contents/MacOS/qts3browser /usr/local/Cellar/qt5/5.11.2/
/usr/local/opt/qt5/bin/macdeployqt s3browser.app -dmg -no-plugins
