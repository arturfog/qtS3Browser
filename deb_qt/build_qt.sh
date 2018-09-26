# download
wget http://download.qt.io/official_releases/qt/5.10/5.10.1/single/qt-everywhere-src-5.10.1.tar.xz
# unpack
tar xf qt-everywhere-src-5.10.1.tar.xz
# update
apt-get update
# dev packages
apt-get install build-essential libfontconfig1-dev libdbus-1-dev libfreetype6-dev libicu-dev libinput-dev libxkbcommon-dev libsqlite3-dev libssl-dev libpng-dev libjpeg-dev libglib2.0-dev
# X11 support
apt-get install libx11-dev libxcb1-dev libxkbcommon-x11-dev libx11-xcb-dev libxext-dev
#
mkdir build
cd build
#
../qt-everywhere-src-5.10.1/configure -v -opengl es2 -eglfs -no-gtk \
-opensource -confirm-license -release -reduce-exports \
-force-pkg-config -no-kms -nomake examples -no-compile-examples -no-pch \
-skip qtwayland -skip qtwebengine -no-feature-geoservices_mapboxgl \
-qt-pcre -ssl -evdev -system-freetype -fontconfig -glib -prefix /opt/Qt5.10
#
make -j4
#
make install
