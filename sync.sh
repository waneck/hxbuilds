#!/bin/sh
echo "s3cmd sync $1 s3://hxbuilds/builds/$2"
s3cmd sync $1 s3://hxbuilds/builds/$2 && exit 0
exit 1
