#!/bin/sh

MAC=$PWD

if [ $# -eq 0 ]; then
        echo "No arguments supplied: $1"
        exit 1
fi

cd ../../repo/haxe
rm -f haxe*
export MACOSX_DEPLOYMENT_TARGET=10.5
make clean && make "ADD_REVISION=1" "OCAMLOPT=x86_64-apple-darwin11-ocamlopt.opt" "OCAMLC=x86_64-apple-darwin11-ocamlopt.opt" && cp haxe $MAC/build/haxe && cp -rf std $MAC/build/ && echo "#!/bin/sh" > $MAC/build/haxelib && echo "haxe --run tools.haxelib.Main %*" >> $MAC/build/haxelib && exit 0
exit 1
