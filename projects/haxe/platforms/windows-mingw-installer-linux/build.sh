#!/bin/bash

WIN=$PWD
if [ $# -lt 2 ]; then
	echo "Too few arguments supplied: $1"
	exit 1
fi

REV=$1
VER=$2
VERLONG=$2

rm -rf tmp
mkdir -p tmp/resources/haxe/doc

if [ ! -e neko-stable.tar.gz ]; then
  echo "In order to have a working installer, you need to provide a neko directory with the desired version"
  exit 1
fi

cd ../../repo/haxe
BRANCH=$(git rev-parse --abbrev-ref HEAD)
ADDREV=1
if [ $BRANCH == "master" ]; then
  ADDREV=0
else
  VER="${2}-dev-$(git describe --always)"
  VERLONG="${2} development snapshot ($(git describe --always))"
fi

# CLEANVER=$(echo $VER | egrep -o [0-9\.]+)
CLEANVER=${2//[^0-9\.]/}
echo "Installer for $VER ($CLEANVER)"

rm -f haxe*
(make clean && make "ADD_REVISION=$ADDREV" "OCAMLOPT=i686-w64-mingw32-ocamlopt" "OCAMLC=i686-w64-mingw32-ocamlc" && cp haxe $WIN/tmp/resources/haxe/haxe.exe && cp -rf std $WIN/tmp/resources/haxe/) || exit 1
i686-w64-mingw32-g++ -static extra/setup.cpp -o $WIN/tmp/resources/haxe/haxesetup.exe || exit 1

# extra
cp extra/{LICENSE,CONTRIB,CHANGES}.txt $WIN/tmp/resources/haxe
cp extra/*.nsi $WIN/tmp
cp extra/*.nsh $WIN/tmp
cp -rf extra/images $WIN/tmp

# neko
tar -zxvf $WIN/neko-stable.tar.gz -C $WIN/tmp/resources
mv $WIN/tmp/resources/neko* $WIN/tmp/resources/neko

# haxelib
cd extra/haxelib_src
haxe haxelib.hxml
mv bin/haxelib.n $WIN/tmp/resources/haxe
cd $WIN/tmp/resources/haxe
neko $WIN/../../platforms/common/boot.n -b ../neko/neko.exe haxelib.n
mv haxelib haxelib.exe
rm haxelib.n

# docs
cd $WIN/repo/dox
git checkout -- .
git fetch
git pull
haxelib dev dox .

rm -rf bin/pages/*
haxe gen.hxml
haxe run.hxml
haxe std.hxml
cp -Rf bin/pages/* $WIN/tmp/resources/haxe/doc

# ready to execute!
cd $WIN/tmp
sed -i "s/%%VERSION%%/$CLEANVER/g" installer.nsi
sed -i "s/%%VERSTRING%%/$VER/g" installer.nsi
sed -i "s/%%VERLONG%%/$VERLONG/g" installer.nsi
makensis installer.nsi || exit 1
cp *.exe ../build

exit 0
