#!/bin/sh
git svn clone https://haxe.googlecode.com/svn/trunk haxe
git svn clone https://ocamllibs.googlecode.com/svn/trunk/ ocamllibs
ln -s ocamllibs haxe/libs
cp -Rf hooks haxe/.git
cp -Rf hooks ocamllibs/.git
