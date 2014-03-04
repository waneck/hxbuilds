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
git clone git@github.com:hogliux/bomutils.git
cd bomutils
make
sudo make install

