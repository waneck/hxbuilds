#!/bin/sh
cd repo/haxe
OLDREV=$(git rev-parse HEAD)
git pull
REV=$(git rev-parse HEAD)
if [ ! $OLDREV = $REV ]; then
	touch ../.updated
fi
