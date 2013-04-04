#!/bin/sh
cd repo
cd ocamllibs
OLDREV=$(git svn find-rev git-svn)
git svn fetch
REV=$(git svn find-rev git-svn)
if [ ! $OLDREV = $REV ]; then
	touch ../.updated
fi

cd ../haxe
OLDREV=$(git svn find-rev git-svn)
git svn fetch
REV=$(git svn find-rev git-svn)
if [ ! $OLDREV = $REV ]; then
	touch ../.updated
fi

cd ../neko
git svn fetch

cd ../../

if [ -f repo/.updated ];
then
	echo "Update exists on $REV!"
	./build.sh $REV && rm repo/.updated
fi
