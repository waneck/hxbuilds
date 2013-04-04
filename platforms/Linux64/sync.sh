#!/bin/sh
s3cmd sync $1/haxe_r$2.tar.gz s3://hxbuilds/builds/linux64/haxe_r$2.tar.gz
