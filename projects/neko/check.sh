#!/bin/sh
cd repo/neko
OLDREV=$(git rev-parse HEAD)
git checkout -- .
git pull
REV=$(git rev-parse HEAD)
if [ ! $OLDREV = $REV ]; then
	touch ../.updated
fi
