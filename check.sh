#!/bin/sh
echo "[$(date)] checking for updates..."
EXITVAR=0
export S3_LOG_PATH=s3://hxbuilds/builds/log
export LOG_PATH=$PWD/log

mkdir -p "$LOG_PATH"

BASE=$PWD
for proj in projects/*; do
	cd $BASE
	echo $proj
	if [ -d "${proj}" ]; then
		PROJECT=$(basename $proj)
		echo "Checking project $PROJECT"
		cd "${proj}"
		./check.sh || PROJEXITVAR=1

		REV=$(./getrev.sh)
		VER=$(./getver.sh)
		PROJEXITVAR=0
		for plat in installed-platforms/*; do
			if [ -f repo/.updated ] && [ -d "${plat}" ]; then
				echo "Building $PROJECT for $(basename $plat)"
				if [ -f repo/.force ]; then
					rm -rf "$BASE/$proj/$plat/build"
				fi
				cd "$BASE/$proj/$plat"
			
				if [ ! -f "build/.r$REV" ] && [ ! -f "out/${PROJECT}_r$REV.tar.gz" ]; then
					rm -rf build
					mkdir build
					neko "$BASE/tools/logger.n" "$PROJECT-$(basename $plat)-build" ./build.sh "$REV" "$VER" && touch "build/.r$REV" || PROJEXITVAR=1
					echo $plat PROJEXITVAR $PROJEXITVAR
				fi
				if [ -f "build/.r$REV" ] || [ -f "out/${PROJECT}_r$REV.tar.gz" ]; then
					rm -rf "$PROJECT-$VER"
					cp -Rf build "$PROJECT-$VER"
					rm -f "$PROJECT-$VER/.r$REV"
					tar -zcvf "out/${PROJECT}_r$REV.tar.gz" "$PROJECT-$VER"
					rm -rf "$PROJECT-$VER"
				else
					PROJEXITVAR=1
					rm -rf "build"
					echo v1 $plat PROJEXITVAR $PROJEXITVAR
				fi

				if [ -f "out/${PROJECT}_r$REV.tar.gz" ]; then
					cd ../../../..
					./sync.sh "$BASE/$proj/${plat}/out/${PROJECT}_r$REV.tar.gz" "$(basename $proj)/$(basename ${plat})/${PROJECT}_$(date -u +'%Y-%m-%d')_$REV.tar.gz" || EXITVAR=1
					./sync.sh "$BASE/$proj/${plat}/out/${PROJECT}_r$REV.tar.gz" "$(basename $proj)/$(basename ${plat})/${PROJECT}_latest.tar.gz" || EXITVAR=1
					echo "neko $BASE/testrunner/bin/runner.n run-project $BASE/$proj $PROJECT $REV"
					neko $BASE/testrunner/bin/runner.n run-project $BASE/$proj $PROJECT "$REV"
					echo "neko $BASE/tools/indexer.n s3://hxbuilds/builds/$(basename $proj)/$(basename $plat)/"
					rm -f index.html
					neko $BASE/tools/indexer.n s3://hxbuilds/builds/$(basename $proj)/$(basename $plat)/ || EXITVAR=1
					if [ -f index.html ]; then
						./sync.sh index.html "$(basename $proj)/$(basename ${plat})/index.html" || EXITVAR=1
					else
						EXITVAR=1
					fi
				else
					PROJEXITVAR=1
          echo v2 PROJEXITVAR $PROJEXITVAR
				fi
			fi
			cd $BASE/$proj
		done

		if [ $PROJEXITVAR = 0 ]; then
			if [ -f repo/.updated ]; then
				echo "removing updated"
				rm repo/.updated
				rm -f repo/.force
			fi
		else
			EXITVAR=1
		fi
	fi
done

cd $LOG_PATH
rm -f index.html
neko $BASE/tools/indexer.n "$S3_LOG_PATH/" || EXITVAR=1
if [ -f index.html ]; then
	"$BASE/sync.sh" index.html "log/index.html" || EXITVAR=1
else
	EXITVAR=1
fi

echo "[$(date)] ended"
exit $EXITVAR
