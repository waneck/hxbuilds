#!/bin/sh
rm /usr/bin/neko
rm /usr/bin/nekoc
rm /usr/bin/nekoml
rm /usr/bin/nekotools
rm /usr/lib/libneko.dylib

ln -s /usr/lib/neko/neko /usr/bin/neko
ln -s /usr/lib/neko/nekoc /usr/bin/nekoc
ln -s /usr/lib/neko/nekoml /usr/bin/nekoml
ln -s /usr/lib/neko/nekotools /usr/bin/nekotools
ln -s /usr/lib/neko/libneko.dylib /usr/lib/libneko.dylib