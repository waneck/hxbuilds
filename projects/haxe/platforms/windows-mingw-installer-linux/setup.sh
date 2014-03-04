#!/bin/sh
sudo apt-get install nsis
mkdir repo
git clone https://github.com/dpeek/dox.git repo/dox
haxelib dev dox repo/dox
