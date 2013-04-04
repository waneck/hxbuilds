#!/bin/sh
cd repo
cd ocamllibs
git svn fetch
cd ../haxe
git svn fetch
REV=$(git svn find-rev git-svn)

cd ../../

if [ -f repo/.updated ];
then
	echo "Update exists on $REV!"
	./build.sh $REV && rm repo/.updated
fi
