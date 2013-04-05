#!/bin/sh

EXITVAR=0

cd repo/haxe
REV=$(git svn find-rev git-svn)
cd ../..

for file in installed-platforms/*; do
  if [ -d "${file}" ]; then
	cd "${file}"
	
	if [ ! -f "build/haxe_r$REV" ] && [ ! -f "out/haxe_r$REV.tar.gz" ]; then
		rm -rf build
		mkdir build
		./build.sh $REV || EXITVAR=1
	fi
	if [ -f build/haxe_r$REV ]; then
		tar -zcvf out/haxe_r$REV.tar.gz build/*
	else
		EXITVAR=1
	fi

	if [ -f out/haxe_r$REV.tar.gz ]; then
		cd ../..
		./sync.sh ${file}/out/haxe_r$REV.tar.gz $(basename ${file})/haxe_r$REV.tar.gz || EXITVAR=1
	else
		EXITVAR=1
	fi
   fi
done

exit $EXITVAR
