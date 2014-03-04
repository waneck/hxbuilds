#!/bin/sh
rm /usr/bin/haxe
rm /usr/bin/haxedoc
rm /usr/bin/haxelib
ln -s /usr/lib/haxe/haxe /usr/bin/haxe
ln -s /usr/lib/haxe/haxedoc /usr/bin/haxedoc
ln -s /usr/lib/haxe/haxelib /usr/bin/haxelib
chmod -Rf 777 /usr/lib/haxe/lib