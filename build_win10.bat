cd .\deb_aws
build.bat
cd ..\
mkdir .\build
cd .\build
cp ..\deb_aws\aws-cpp-sdk\build\aws-cpp-sdk-core\*.dll .
cp ..\deb_aws\aws-cpp-sdk\build\aws-cpp-sdk-transfer\*.dll .
cp ..\deb_aws\aws-cpp-sdk\build\aws-cpp-sdk-s3\*.dll .
qmake -v && qmake ..\s3Browser.pro CONFIG+=release && mingw64-make
