#!/bin/bash
brew install qt5 2>&1 > /dev/null
brew link qt5 --force

# AWS
cd deb_aws && ./build.sh

# QTS3BROWSER

mkdir build && cd build

# copy AWS
cp -vf ../deb_aws/aws-cpp-sdk/build/aws-cpp-sdk-core/*.dylib .
cp -vf ../deb/aws/aws-cpp-sdk/build/aws-cpp-sdk-transfer/*.dylib .
cp -vf ../deb/aws/aws-cpp-sdk/build/aws-cpp-sdk-s3/*.dylib .

/usr/local/opt/qt5/bin/qmake ../s3Browser.pro CONFIG+=release && make
/usr/local/opt/qt5/bin/macdeployqt qts3browser.app -always-overwrite -verbose=2 -qmldir=qml

curl -o /tmp/macdeployqtfix.py https://raw.githubusercontent.com/aurelien-rainone/macdeployqtfix/master/macdeployqtfix.py

python /tmp/macdeployqtfix.py ./qts3browser.app/Contents/MacOS/qts3browser /usr/local/Cellar/qt5/5.11.2_1/

/usr/local/opt/qt5/bin/macdeployqt qts3browser.app -dmg -no-plugins
