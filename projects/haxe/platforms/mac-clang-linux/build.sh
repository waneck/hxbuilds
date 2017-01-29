#!/bin/bash

MAC=$PWD

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
export MACOSX_DEPLOYMENT_TARGET=10.5
(make clean && make "STATICLINK=1" "ADD_REVISION=$ADDREV" "OCAMLOPT=x86_64-apple-darwin11-ocamlopt.opt" "OCAMLC=x86_64-apple-darwin11-ocamlopt.opt" libs haxe && cp haxe $MAC/build/haxe && cp -rf std $MAC/build/) || exit 1
mkdir -p $MAC/tmp/haxe
cp extra/{LICENSE,CONTRIB,CHANGES}.txt $MAC/tmp/haxe

# haxelib
cd extra/haxelib_src
haxe client.hxml
mv run.n $MAC/build
cd $MAC/build
neko $MAC/../../platforms/common/boot.n -b $MAC/../../platforms/common/neko-mac run.n
mv run haxelib
rm run.n
