#!/bin/bash

LNX=$PWD

if [ $# -eq 0 ]; then
	echo "No arguments supplied: $1"
	exit 1
fi

mkdir -p out
mkdir -p build

cd ../../repo/haxe
HAXEREPO=$PWD
BRANCH=$(git rev-parse --abbrev-ref HEAD)
ADDREV=1
if [ $BRANCH == "master" ]; then
  ADDREV=0
fi
rm -f haxe*
(make clean && make all "STATICLINK=1" "ADD_REVISION=$ADDREV" && make tools && cp haxe* $LNX/build/ && cp -rf std $LNX/build/) || exit 1
mkdir -p $LNX/tmp/haxe
cp extra/{LICENSE,CONTRIB,CHANGES}.txt $LNX/tmp/haxe

# haxelib
cd extra/haxelib_src
haxe client.hxml
mv run.n $LNX/build/haxelib.n
cd $LNX/build
nekotools boot haxelib.n
rm haxelib.n

mkdir -p $LNX/build/extra
cp -Rf "$HAXEREPO/extra/haxelib_src" $LNX/build/extra

rm -rf /usr/lib/haxe/std
cp -Rf $LNX/../../repo/haxe/std /usr/lib/haxe
cp -Rf $LNX/build/* /usr/lib/haxe
