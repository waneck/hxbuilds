#!/bin/bash

WIN=$PWD

cd ../../repo/haxe
BRANCH=$(git rev-parse --abbrev-ref HEAD)
ADDREV=1
if [ $BRANCH == "master" ]; then
  ADDREV=0
fi
rm -f haxe*
(make clean && make "ADD_REVISION=$ADDREV" "OCAMLOPT=i686-w64-mingw32-ocamlopt" "OCAMLC=i686-w64-mingw32-ocamlc" libs haxe && cp haxe $WIN/build/haxe.exe && cp -rf std $WIN/build/) || exit 1
mkdir -p $WIN/build
cp extra/{LICENSE,CONTRIB,CHANGES}.txt $WIN/build

# haxelib
cd extra/haxelib_src
haxe client.hxml
mv run.n $WIN/build
cd $WIN/build
neko $WIN/../../platforms/common/boot.n -b $WIN/../../platforms/common/neko-win.exe run.n
mv run haxelib.exe
rm run.n
