#!/bin/sh
cd repo/haxe
OLDREV=$(git rev-parse HEAD)
git submodule update
git pull
git submodule update
REV=$(git rev-parse HEAD)
if [ ! $OLDREV = $REV ]; then
	touch ../.updated
fi
