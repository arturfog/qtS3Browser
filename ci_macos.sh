#!/bin/bash
# Travis checkout dir
#
# /Users/travis/build/arturfog/qtS3Browser
HOMEBREW_NO_AUTO_UPDATE=1 brew install qt5 2>&1 > /dev/null
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

cp libaws-cpp-sdk*.dylib ./s3browser.app/Contents/Frameworks/
install_name_tool -id libaws-cpp-sdk-core.dylib s3browser.app/Contents/Frameworks/libaws-cpp-sdk-core.dylib
install_name_tool -change @rpath/libaws-cpp-sdk-core.dylib @executable_path/../Frameworks/libaws-cpp-sdk-core.dylib s3browser.app/Contents/MacOS/s3browser

install_name_tool -id libaws-cpp-sdk-s3.dylib s3browser.app/Contents/Frameworks/libaws-cpp-sdk-s3.dylib
install_name_tool -change @rpath/libaws-cpp-sdk-s3.dylib @executable_path/../Frameworks/libaws-cpp-sdk-s3.dylib s3browser.app/Contents/MacOS/s3browser

install_name_tool -id libaws-cpp-sdk-transfer.dylib s3browser.app/Contents/Frameworks/libaws-cpp-sdk-transfer.dylib
install_name_tool -change @rpath/libaws-cpp-sdk-transfer.dylib @executable_path/../Frameworks/libaws-cpp-sdk-transfer.dylib s3browser.app/Contents/MacOS/s3browser

/usr/local/opt/qt5/bin/macdeployqt s3browser.app -dmg -no-plugins

ls -l

mkdir deploy
cp ./s3browser.dmg deploy
