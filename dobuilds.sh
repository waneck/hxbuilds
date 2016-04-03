#!/bin/sh
cd $(dirname $0)

while true; do
  git pull
  git pull >> ../hxpull.log 2>> ../hxpull.error
  cd tools
  haxe build-indexer.hxml
  haxe build-logger.hxml
  cd ..
  echo vai
  /bin/bash -x ./check.sh > ../hxbuilds.log 2>&1
  echo espera
  sleep 10
done
