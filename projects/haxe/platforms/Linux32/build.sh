#!/bin/sh

LNX=$PWD

if [ $# -eq 0 ]; then
	echo "No arguments supplied: $1"
	exit 1
fi

echo "build/haxe_r$1"
cd ../../repo/haxe
rm haxe
make clean && make all && cp haxe $LNX/build/haxe_r$1 && cp -rf std $LNX/build/
cd $LNX
