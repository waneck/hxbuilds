#!/bin/bash

LNX=$PWD

if [ $# -eq 0 ]; then
	echo "No arguments supplied: $1"
	exit 1
fi

cd ../../repo/neko
rm -rf bin
if [ $(uname -m) = "i686" ]; then
  make clean && make all "CFLAGS= -Wall -O3 -fPIC -fomit-frame-pointer -I vm -D_GNU_SOURCE -I libs/common -mincoming-stack-boundary=2" && cp -rf bin $LNX/build/ && exit 0
else
  make clean && make all && cp -rf bin $LNX/build/ && exit 0
fi
exit 1
