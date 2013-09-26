#!/bin/sh

WIN=$PWD

if [ $# -eq 0 ]; then
        echo "No arguments supplied: $1"
        exit 1
fi

cd ../../repo/haxe
rm -f haxe*
make clean && make "ADD_REVISION=1" "OCAMLOPT=i686-w64-mingw32-ocamlopt" "OCAMLC=i686-w64-mingw32-ocamlc" && cp haxe $WIN/build/haxe.exe && cp -rf std $WIN/build/ && echo "haxe --run tools.haxelib.Main %*" > $WIN/build/haxelib.bat && exit 0
exit 1
