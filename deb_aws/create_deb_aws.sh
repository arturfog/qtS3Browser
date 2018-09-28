#!/bin/bash
#
# This script creates AWS S3 libs debian package

cleanup() {
rm -rf amazon-s3-cpp-sdk-1.6.0
rm *.dsc
rm *.tar.gz
rm *.changes
}

cleanup

# checkout 
git clone --depth 1 https://github.com/aws/aws-sdk-cpp.git
mv aws-sdk-cpp amazon-s3-cpp-sdk-1.6.0

# copy debian directory
cp -vfr debian amazon-s3-cpp-sdk-1.6.0

# Build package
cd amazon-s3-cpp-sdk-1.6.0
dpkg-buildpackage -rfakeroot -I.git

cd ..
cleanup
