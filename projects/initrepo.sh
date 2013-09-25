#!/bin/sh
mkdir -p haxe/repo
mkdir -p neko/repo
git clone --recursive git@github.com:HaxeFoundation/haxe.git haxe/repo/haxe
git clone --recursive git@github.com:HaxeFoundation/neko.git neko/repo/neko
touch haxe/repo/.updated
touch neko/repo/.updated
