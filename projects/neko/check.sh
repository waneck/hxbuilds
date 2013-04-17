#!/bin/sh
cd repo/neko
OLDREV=$(git svn find-rev git-svn)
git svn fetch
git svn rebase
REV=$(git svn find-rev git-svn)
if [ ! $OLDREV = $REV ]; then
	touch ../.updated
fi
