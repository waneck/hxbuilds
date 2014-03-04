#!/bin/bash

WIN=$PWD

cd ../../repo/haxe
BRANCH=$(git rev-parse --abbrev-ref HEAD)
ADDREV=1
if [ $BRANCH == "master" ]; then
  ADDREV=0
fi
rm -f haxe*
make clean && make "ADD_REVISION=$ADDREV" "OCAMLOPT=i686-w64-mingw32-ocamlopt" "OCAMLC=i686-w64-mingw32-ocamlc" && cp haxe $WIN/build/haxe.exe && cp -rf std $WIN/build/ && echo "haxe --run tools.haxelib.Main %*" > $WIN/build/haxelib.bat && exit 0
exit 1
