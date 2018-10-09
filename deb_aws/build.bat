git clone --depth 1 https://github.com/aws/aws-sdk-cpp.git

cd aws-sdk-cpp

mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DENABLE_TESTING=OFF -DBUILD_ONLY=s3 -DBUILD_ONLY=transfer ..

cmake --build -j 2 . 

cd ..\..\
