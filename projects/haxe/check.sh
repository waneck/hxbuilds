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
