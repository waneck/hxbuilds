#!/bin/sh
cd $(dirname $0)
# haxe
chmod +x *
./haxe-preinstall.sh
rm -f /usr/lib/haxe
mkdir -p /usr/lib/haxe
cp -Rf ../haxe/* /usr/lib/haxe
./haxe-postinstall.sh
./neko-preinstall.sh
rm -f /usr/lib/neko
mkdir -p /usr/lib/neko
cp -Rf ../neko/* /usr/lib/neko
./neko-postinstall.sh
cd ../
rm -Rf /tmp/haxe
