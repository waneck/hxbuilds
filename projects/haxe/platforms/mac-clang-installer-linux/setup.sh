#!/bin/sh
mkdir repo
cd repo

#dox
git clone https://github.com/dpeek/dox.git dox
haxelib dev dox repo/dox

#xar
sudo apt-get install gcc libssl-dev libxml2-dev make
wget http://xar.googlecode.com/files/xar-1.5.2.tar.gz
tar -zxvf xar-1.5.2.tar.gz
cd xar-1.5.2
./configure
make
sudo make install
cd ..

#mkbom
git clone https://github.com/hogliux/bomutils.git
cd bomutils
make
sudo make install
cd ..

# hxjava
git clone https://github.com/HaxeFoundation/hxjava.git
haxelib dev hxjava hxjava

# hxcs
git clone https://github.com/HaxeFoundation/hxcs.git
haxelib dev hxcs hxcs

# boot neko
#cd ../../platforms/common
#nekoc boot.neko

haxelib install hxargs
haxelib install markdown
