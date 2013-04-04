#!/bin/sh

LNX=$(CWD)

echo "build/haxe_r$1"
if [ ! -f "build/haxe_r$1" && ! -f "out/haxe_r$1.tar.gz" ] then
	rm -rf build
	mkdir build
	cd ../../repo/haxe
	rm haxe
	make clean && make all cp haxe $LNX/build/haxe_r$1 && cp -rf std $LNX/build/
	cd $LNX
fi

if [ -f build/haxe_r$1 ] then
	tar -zcvf out/haxe_r$1.tar.gz build/*
else
	exit 1
fi

if [ -f out/haxe_r$1.tar.gz ] then
	./sync.sh out $1
else
	exit 1
fi
