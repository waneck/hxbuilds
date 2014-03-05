#!/bin/bash

WIN=$PWD

cd ../../repo/haxe
BRANCH=$(git rev-parse --abbrev-ref HEAD)
ADDREV=1
if [ $BRANCH == "master" ]; then
  ADDREV=0
fi
rm -f haxe*
(make clean && make "ADD_REVISION=$ADDREV" "OCAMLOPT=i686-w64-mingw32-ocamlopt" "OCAMLC=i686-w64-mingw32-ocamlc" && cp haxe $WIN/build/haxe.exe && cp -rf std $WIN/build/) || exit 1
cp extra/*.txt $WIN/build

# haxelib
cd extra/haxelib_src
haxe haxelib.hxml
mv bin/haxelib.n $WIN/build
cd $WIN/build
neko $WIN/../../platforms/common/boot.n -b $WIN/../../platforms/common/neko-win.exe haxelib.n
mv haxelib haxelib.exe
rm haxelib.n
