#!/bin/bash
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
PATH=$PATH:$PWD/depot_tools
mkdir crashpad
cd crashpad
fetch crashpad
cd crashpad
gn gen out/Default --args='target_cpu="x64" is_debug=true'
ninja -C out/Default
mkdir ../crashpad_libs
find . -name '*.a' -exec cp -f {} ../crashpad_libs/ \;
