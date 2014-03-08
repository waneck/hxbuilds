#!/bin/sh
cd $(dirname $0)
git pull >> ../hxpull.log 2>> ../hxpull.error
cd testrunner
haxe build.hxml
cd ..
./check.sh >> ../hxbuilds.log 2>> ../hxbuilds.error
