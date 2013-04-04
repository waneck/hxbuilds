#!/bin/sh

EXITVAR=0

for file in platforms/*; do
   if [ -d $file ]; then
      cd $file
			./build.sh sync_out || EXITVAR=1
   fi
done

exit $EXITVAR
