#!/bin/bash
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

OLDVER=$(git describe --tags $(git rev-list --tags --max-count=1))
OLDREV=$(git rev-parse HEAD)
git submodule update
git pull || exit 1
git submodule update || exit 1
VER=$(git describe --tags $(git rev-list --tags --max-count=1))
REV=$(git rev-parse HEAD)
if [ ! $OLDREV = $REV ]; then
	touch ../.updated
fi
echo "$VER - $OLDVER"
if [ ! $VER = $OLDVER ]; then
  # ensure we're on master
  git checkout master
  touch ../.updated
fi
exit 0
