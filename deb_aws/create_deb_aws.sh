#!/bin/bash
#
# This script creates AWS S3 libs debian package

cleanup() {
rm -rf amazon-s3-cpp-sdk-1.8.142
rm *.dsc
rm *.tar.gz
rm *.changes
}

cleanup

# checkout 
git clone --depth 1 https://github.com/aws/aws-sdk-cpp.git
mv aws-sdk-cpp amazon-s3-cpp-sdk-1.8.142

# copy debian directory
cp -vfr debian amazon-s3-cpp-sdk-1.8.142

# Build package
cd amazon-s3-cpp-sdk-1.8.142
dpkg-buildpackage -rfakeroot -I.git

cd ..
cleanup
