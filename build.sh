#!/bin/sh

EXITVAR=0

cd repo/haxe
REV=$(git svn find-rev git-svn)
cd ../..

for file in platforms/*; do
  if [ -d "${file}" ]; then
		cd "${file}"
		./build.sh $REV || EXITVAR=1
   fi
done

exit $EXITVAR
