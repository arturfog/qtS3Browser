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

echo -n "Intalling AWS ..."
sudo apt-get install -y zlib1g-dev libssl-dev libcurl4-openssl-dev
git clone --depth 1 https://github.com/aws/aws-sdk-cpp.git
cd aws-sdk-cpp
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DENABLE_TESTING=OFF -DBUILD_ONLY=s3 -DBUILD_ONLY=transfer
make -j 2
make DESTDIR=$HOME/.local install
echo "[ OK ]"

#sudo apt-get install libssl1.0.0 zlib1g libcurl3 libkrb5-3 libgssapi3-heimdal libroken18-heimdal libgnutls30 libp11-kit0 libstdc++6 libgcc1 libdb5.3

echo -n "Intalling QT ..."
DISTRO=`cat /etc/lsb-release | grep CODENAME | cut -d= -f 2`

# QT5 in ubuntu < 18.04 is too old for this app
if [ "$DISTRO" != "bionic" ]; then
  git clone -b "5.9" --single-branch https://code.qt.io/qt/qt5.git
  cd qt5
  git submodule update --init --recursive
  ./configure -developer-build -opensource -nomake examples -nomake tests
  make -j4
  # On systems with X11 ubuntu can be installed using online installer
  # wget 'http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run'
else
sudo apt -y install \
libqt5concurrent5 \
libqt5core5a \
libqt5dbus5 \
libqt5gui5 \
libqt5network5 \
libqt5opengl5 \
libqt5opengl5-dev \
libqt5printsupport5 \
libqt5qml5 \
libqt5quick5 \
libqt5quickparticles5 \
libqt5quicktest5 \
libqt5quickwidgets5 \
libqt5sql5 \
libqt5sql5-sqlite \
libqt5svg5 \
libqt5test5 \
libqt5widgets5 \
libqt5xml5 \
qt5-gtk-platformtheme \
qt5-qmake \
qt5-qmake-bin \
qt5-qmltooling-plugins \
qtbase5-dev \
qtbase5-dev-tools \
qtchooser \
qtdeclarative5-dev \
qttranslations5-l10n
fi
echo "[OK]"

echo -n "Creating build directory ..."
mkdir ../qts3browser_build
cd ../qts3browser_build
echo "[ OK ]"

qmake -o Makefile ../qtS3Browser/s3Browser.pro -spec linux-g++ CONFIG+=debug CONFIG+=qml_debug
