#!/bin/sh
git svn clone https://haxe.googlecode.com/svn/trunk haxe
git svn clone https://ocamllibs.googlecode.com/svn/trunk/ ocamllibs
git svn clone https://nekovm.googlecode.com/svn/trunk neko
ln -s ../ocamllibs haxe/libs
cp -Rf hooks haxe/.git
cp -Rf hooks ocamllibs/.git
cp -Rf hooks neko/.git
