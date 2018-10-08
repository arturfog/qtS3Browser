#!/bin/bash
# TODO: add colors to printed statuses
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo ${machine}

if [ "${machine}" != "Mac" ]; then
	echo "Error. Please run script on MacOS !"
	exit 1
fi

brew install qt5 2>&1 > /dev/null
brew link qt5 --force

mkdir build
cd build

/usr/local/opt/qt5/bin/qmake ../s3Browser.pro CONFIG+=release;

make

/usr/local/opt/qt5/bin/macdeployqt qts3browser.app -always-overwrite -verbose=2 -qmldir=qml

curl -o /tmp/macdeployqtfix.py https://raw.githubusercontent.com/aurelien-rainone/macdeployqtfix/master/macdeployqtfix.py

python /tmp/macdeployqtfix.py ./qts3browser.app/Contents/MacOS/qts3browser /usr/local/Cellar/qt5/5.11.2_1/

/usr/local/opt/qt5/bin/macdeployqt qts3browser.app -dmg -no-plugins
