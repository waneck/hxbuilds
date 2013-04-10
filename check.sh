#!/bin/sh
EXITVAR=0

for proj in projects/*; do
	if [ -d "${proj}" ]; then
		cd "${proj}"
		./check.sh || EXITVAR=1

		REV=$(./getver.sh)
		BASE=$PWD
		PROJECT=$(basename $proj)
		PROJEXITVAR=0
		for plat in installed-platforms/*; do
			if [ -f repo/.updated ] && [ -d "${plat}" ]; then
				cd "$BASE/$plat"
			
				if [ ! -f "build/.r$REV" ] && [ ! -f "out/${PROJECT}_r$REV.tar.gz" ]; then
					rm -rf build
					mkdir build
					./build.sh $REV && touch build/.r$REV || PROJEXITVAR=1
				fi
				if [ -f build/.r$REV ]; then
					tar -zcvf out/${PROJECT}_r$REV.tar.gz build/*
				else
					PROJEXITVAR=1
				fi

				if [ -f out/${PROJECT}_r$REV.tar.gz ]; then
					cd ../../../..
					./sync.sh $BASE/${plat}/out/${PROJECT}_r$REV.tar.gz $(basename ${plat})/${PROJECT}_r$REV.tar.gz || EXITVAR=1
				else
					PROJEXITVAR=1
				fi
			fi
			cd $BASE
		done

		if [ $PROJEXITVAR -eq 0 ]; then
			if [ -f repo/.updated ]; then
				echo "removing updated"
				rm repo/.updated
			fi
		else
			EXITVAR=1
		fi
	fi
done

exit $EXITVAR
