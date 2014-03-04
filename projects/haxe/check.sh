#!/bin/sh
cd repo/haxe
if [ ! -e ../.updated ]; then
	BRANCH=$(git rev-parse --abbrev-ref HEAD)
	if [ $BRANCH == "development" ]; then
		echo "checking master"
		git checkout master
	else
		echo "checking development"
		git checkout development
	fi
fi

OLDREV=$(git rev-parse HEAD)
git submodule update
git pull
git submodule update
REV=$(git rev-parse HEAD)
if [ ! $OLDREV = $REV ]; then
	touch ../.updated
fi
