#!/bin/bash

WIN=$PWD

if [ $# -eq 0 ]; then
        echo "No arguments supplied: $1"
        exit 1
fi

cd ../../repo/haxe
BRANCH=$(git rev-parse --abbrev-ref HEAD)
ADDREV=1
if [ $BRANCH == "master" ]; then
  ADDREV=0
fi
rm -f haxe*
make clean && make "STATICLINK=1" "ADD_REVISION=$ADDREV" "OCAMLOPT=x86_64-w64-mingw32-ocamlopt" "OCAMLC=x86_64-w64-mingw32-ocamlc" && cp haxe $WIN/build/haxe.exe && cp -rf std $WIN/build/ && echo "haxe --run tools.haxelib.Main %*" > $WIN/build/haxelib.bat && exit 0
exit 1
