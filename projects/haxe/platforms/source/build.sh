#!/bin/bash

SRC=$PWD

if [ $# -eq 0 ]; then
	echo "No arguments supplied: $1"
	exit 1
fi

mkdir -p out
mkdir -p build

cd ../../repo/haxe
rm haxe*
make clean
cp -rf * $SRC/build/ || exit 1
