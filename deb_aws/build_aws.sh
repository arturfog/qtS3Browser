#!/bin/bash
# install build deps
sudo apt-get install -y zlib1g-dev libssl-dev libcurl4-openssl-dev
# checkout
git clone --depth 1 https://github.com/aws/aws-sdk-cpp.git
cd aws-sdk-cpp
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DENABLE_TESTING=OFF -DBUILD_ONLY=s3 -DBUILD_ONLY=transfer
make -j 8
# install run deps
#sudo apt-get install libssl1.0.0 zlib1g libcurl3 libkrb5-3 libgssapi3-heimdal libroken18-heimdal libgnutls30 libp11-kit0 libstdc++6 libgcc1 libdb5.3
