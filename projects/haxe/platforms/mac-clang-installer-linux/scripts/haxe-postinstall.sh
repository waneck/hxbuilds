#!/bin/sh
rm -f /usr/bin/haxe
rm -f /usr/bin/haxedoc
rm -f /usr/bin/haxelib
ln -s /usr/lib/haxe/haxe /usr/bin/haxe
cp /usr/lib/haxe/haxelib /usr/bin/haxelib
chmod -Rf 777 /usr/lib/haxe/lib
