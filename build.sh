#!/bin/sh

EXITVAR=0

for file in platforms/*; do
  if [ -d "${file}" ]; then
		cd "${file}"
		./build.sh $1 || EXITVAR=1
   fi
done

exit $EXITVAR
