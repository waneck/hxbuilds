#!/bin/bash

LNX=$PWD

if [ $# -eq 0 ]; then
	echo "No arguments supplied: $1"
	exit 1
fi

mkdir -p out
mkdir -p build

cd ../../repo/haxe
BRANCH=$(git rev-parse --abbrev-ref HEAD)
ADDREV=1
if [ $BRANCH == "master" ]; then
  ADDREV=0
fi
rm haxe*
(make clean && make all "ADD_REVISION=$ADDREV" && make tools && cp haxe* $LNX/build/ && cp -rf std $LNX/build/) || exit 1
cp extra/*.txt $LNX/build
mkdir -p $LNX/build/extra
cp -Rf extra/haxelib_src $LNX/build/extra

cp -Rf $LNX/build/* /usr/lib/haxe

