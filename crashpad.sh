#!/bin/bash
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
PATH=$PATH:$PWD/depot_tools
mkdir crashpad
cd crashpad
fetch crashpad
cd crashpad
gn gen out/Default
ninja -C out/Default
