#!/bin/sh
mkdir -p haxe/repo
mkdir -p neko/repo
git svn clone https://haxe.googlecode.com/svn/trunk haxe/repo/haxe
git svn clone https://ocamllibs.googlecode.com/svn/trunk/ haxe/repo/ocamllibs
git svn clone https://nekovm.googlecode.com/svn/trunk neko/repo/neko
ln -s ../ocamllibs haxe/repo/haxe/libs
touch haxe/repo/.updated
touch neko/repo/.updated
