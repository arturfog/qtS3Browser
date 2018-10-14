call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86

set QTDIR=C:\Qt\5.11.1\msvc2015
set PATH=C:\Program Files (x86)\MSBuild\12.0\bin;%MINGW_PATH%\bin;C:\msys\bin\;%QTDIR%\bin;%PATH%

cd .\deb_aws

git clone --depth 1 https://github.com/aws/aws-sdk-cpp.git
cd aws-sdk-cpp && mkdir build && cd build
cmake -DBUILD_SHARED_LIBS=ON -DENABLE_TESTING=OFF -DBUILD_ONLY=s3 -DBUILD_ONLY=transfer ..
cmake --build . -j 4

cd ..\
mkdir .\build
cd .\build
cp ..\deb_aws\aws-cpp-sdk\build\aws-cpp-sdk-core\*.dll .
cp ..\deb_aws\aws-cpp-sdk\build\aws-cpp-sdk-transfer\*.dll .
cp ..\deb_aws\aws-cpp-sdk\build\aws-cpp-sdk-s3\*.dll .

mkdir .\build && cd .\build
qmake -v && qmake ..\s3Browser.pro CONFIG+=release -spec win32-msvc && nmake /f Makefile.Release

windeployqt --qmldir ..\qml release\s3browser.exe --dir distrib
      cp c:\projects\aws\aws-cpp-sdk-*.dll distrib
      cp c:\projects\aws\aws-cpp-sdk-*.lib distrib
      7z a -y distrib.zip distrib

set PATH=%PATH%;"C:\Program Files (x86)\Inno Setup 5"
ISCC /Q ..\qts3browser.iss
