#!/bin/sh
#!/bin/sh
cd /var/dev/hxbuilds
git pull >> ../hxpull.log 2>> ../hxpull.error
#cd testrunner
#haxe build.hxml
#cd ..
./check.sh >> ../hxbuilds.log 2>> ../hxbuilds.error
