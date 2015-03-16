#!/bin/bash
cd repo/haxe
if [ ! -e ../.updated ]; then
	BRANCH=$(git rev-parse --abbrev-ref HEAD)
	if [ $BRANCH == "development" ]; then
		echo "checking master"
		git checkout origin/master
		git checkout -B master
	else
		echo "checking development"
		git checkout origin/development
		git checkout -B development
	fi
fi

OLDVER=$(git rev-list --tags --max-count=1)
OLDREV=$(git rev-parse HEAD)
git submodule update --force --recursive
git fetch
git pull origin `git name-rev --name-only HEAD` || exit 1
git submodule update --force --recursive || exit 1
VER=$(git rev-list --tags --max-count=1)
REV=$(git rev-parse HEAD)
if [ ! $OLDREV = $REV ]; then
	touch ../.updated
fi
echo "$VER - $OLDVER"
if [ ! $VER = $OLDVER ]; then
  # ensure we're on master
  git checkout master
  touch ../.updated
	touch ../.force
fi
exit 0
