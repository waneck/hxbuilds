#!/bin/sh

LNX=$PWD

if [ $# -eq 0 ]; then
	echo "No arguments supplied: $1"
	exit 1
fi

cd ../../repo/haxe
rm haxe
make clean && make all && cp haxe $LNX/build/haxe && cp -rf std $LNX/build/ && exit 0
exit 1
