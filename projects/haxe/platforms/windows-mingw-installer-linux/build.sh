#!/bin/bash

WIN=$PWD
if [ $# -lt 2 ]; then
	echo "Too few arguments supplied: $1"
	exit 1
fi

REV=$1
VER=$2

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
  VER=$2 dev-$(git describe --always)
fi

rm -f haxe*
(make clean && make "ADD_REVISION=$ADDREV" "OCAMLOPT=i686-w64-mingw32-ocamlopt" "OCAMLC=i686-w64-mingw32-ocamlc" && cp haxe $WIN/tmp/resources/haxe/haxe.exe && cp -rf std $WIN/tmp/resources/haxe/) || exit 1

# extra
cp extra/*.txt $WIN/tmp/resources/haxe
cp extra/*.nsi $WIN/tmp
cp extra/*.nsh $WIN/tmp
cp -rf extra/images $WIN/tmp

# neko
tar -zxvf $WIN/neko-stable.tar.gz -C $WIN/tmp/resources
mv $WIN/tmp/resources/neko* $WIN/tmp/resources/neko

# haxelib
cd extra/haxelib_src
haxe haxelib.hxml
cp bin/haxelib.n $WIN/tmp/resources/haxe
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
haxe gen.hxml || exit 1
haxe std.hxml || exit 1
cp -Rf bin/pages/* $WIN/tmp/resources/haxe/doc || exit 1

# ready to execute!
sed 's/%%VERSION%%/$VER/g' installer.nsi
cd $WIN/tmp
makensis installer.nsi || exit 1
cp *.exe ../build

exit 0
