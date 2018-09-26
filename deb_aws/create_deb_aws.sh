#!/bin/bash
#
# This script creates AWS debian package
rm -rf amazon-s3-cpp-sdk-1.6.0
git clone --depth 1 https://github.com/aws/aws-sdk-cpp.git
mv aws-sdk-cpp amazon-s3-cpp-sdk-1.6.0
cp -vfr debian amazon-s3-cpp-sdk-1.6.0
cd amazon-s3-cpp-sdk-1.6.0
# Build package
dpkg-buildpackage -rfakeroot -I.git
