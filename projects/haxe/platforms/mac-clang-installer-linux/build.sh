#!/bin/bash

MAC=$PWD
if [ $# -lt 2 ]; then
	echo "Too few arguments supplied: $1"
	exit 1
fi

REV=$1
VER=$2
VERLONG=$2
NEKOVER=2.0.0

rm -rf tmp
mkdir -p out
mkdir -p tmp/haxe/doc
mkdir -p tmp/installer

if [ ! -e neko-stable.tar.gz ]; then
  echo "In order to have a working installer, you need to provide a neko directory with the desired version"
  exit 1
fi

if [ ! -d scripts ]; then
	echo "Error: scripts folder not found"
	exit 1
fi

# update projects

cd repo/hxjava
git pull origin master
cd ../hxcs
git pull origin master

cd ../../

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
export MACOSX_DEPLOYMENT_TARGET=10.5
(make clean && make "ADD_REVISION=$ADDREV" "OCAMLOPT=x86_64-apple-darwin11-ocamlopt.opt" "OCAMLC=x86_64-apple-darwin11-ocamlopt.opt" && cp haxe $MAC/tmp/haxe && cp -rf std $MAC/tmp/haxe/) || exit 1

# extra
cp extra/*.txt $MAC/tmp/haxe
mkdir $MAC/tmp/haxe/lib-client
chmod 777 $MAC/tmp/haxe/lib-client

# neko
tar -zxvf $MAC/neko-stable.tar.gz -C $MAC/tmp
mv $MAC/tmp/neko* $MAC/tmp/neko

# haxelib
cd extra/haxelib_src
haxe haxelib.hxml
cp bin/haxelib.n $MAC/tmp/haxe
cd $MAC/tmp/haxe
neko $MAC/../../platforms/common/boot.n -b ../neko/neko haxelib.n
rm haxelib.n

# docs
cd $MAC/repo/dox
git checkout -- .
git fetch
git pull
haxelib dev dox .
rm -rf bin/pages/*
haxe gen.hxml || exit 1
haxe std.hxml || exit 1
cp -Rf bin/pages/* $MAC/tmp/haxe/doc || exit 1

# ready to execute!
cd $MAC/tmp
mkdir files
mv haxe files
mv neko files
cp -Rf ../scripts files
cd files
tar -zcvf haxe.tar.gz haxe
tar -zcvf neko.tar.gz neko
tar -zcvf scripts.tar.gz scripts
rm -rf haxe neko scripts

cd ../installer
xar -xf ../../installer-structure.pkg .

# edit haxe
cd files.pkg
rm Payload
cd ../../files
find . | cpio -o --format odc | gzip -c > ../installer/files.pkg/Payload
cd ../installer/files.pkg
INSTKB=$(du -sk ../../files)
INSTKBH=$(expr ${INSTKB//[^0-9]/} - 4)
sed -i "s/%%INSTKB%%/$INSTKBH/g" PackageInfo
sed -i "s/%%VERSION%%/$CLEANVER/g" PackageInfo
sed -i "s/%%VERSTRING%%/$VER/g" PackageInfo
sed -i "s/%%VERLONG%%/$VERLONG/g" PackageInfo
sed -i "s/%%NEKOVER%%/$NEKOVER/g" PackageInfo
cd ..

sed -i "s/%%VERSION%%/$CLEANVER/g" Distribution
sed -i "s/%%VERSTRING%%/$VER/g" Distribution
sed -i "s/%%VERLONG%%/$VERLONG/g" Distribution
sed -i "s/%%NEKOVER%%/$NEKOVER/g" Distribution
sed -i "s/%%INSTKB%%/$INSTKBH/g" Distribution

# repackage
xar --compression none -cf ../../build/haxe-${VER}.pkg *

exit 0
