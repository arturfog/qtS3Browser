#!/bin/bash
if [ -z "$1" ]; then
  echo 'Please execute with gpg password: ./upload_deb.sh [gpg password]'
  exit
fi

if [ -z "$API_KEY" ]; then
  echo 'Please export your bintray api key as env variable API_KEY: export API_KEY="0000000000000000"'
  exit
fi

curl -v -T 'qt-everywhere_5.10.0_amd64.deb' -H 'X-Bintray-Debian-Distribution: xenial' -H 'X-Bintray-Debian-Component: main' -H 'X-Bintray-Debian-Architecture: amd64' -H "X-GPG-PASSPHRASE: $1" -uarturfog:${API_KEY} https://api.bintray.com/content/arturfog/oss-arturfog/qt-everywhere/5.10.0/qt-everywhere_5.10.0_amd64.deb
