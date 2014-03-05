hxbuilds
========

simple haxe build server script

## Configuring your own build server instance

- install and configure s3cmd
- install chosen ocaml version / cross-compilers
- for neko, install build essential and optionally the following libraries:
  - TBD

### Initial setup
```bash
# warning: the scripts update automatically. If you want to disable / have control over this feature, fork your own hxbuilds and clone that repo instead
git clone https://github.com/waneck/hxbuilds.git

# initialize haxe / neko repos
cd hxbuilds/projects
./initrepo.sh

# setup haxe
cd haxe
# select which platforms you want to build for
mkdir installed-platforms && cd installed-platforms
ln -s ../platforms/nix ./platform-name # e.g. linux32 on 32-bits, linux64 on 64 and so on
# repeat the above for any other platform you want to build

# setup neko
cd ../../neko
# select which platforms you want to build for
mkdir installed-platforms && cd installed-platforms
ln -s ../platforms/nix .
# repeat the above for any other platform you want to build

# go back to the hxbuilds root
cd ../../../
# try to see if everything builds correctly
./check.sh

# if everything was setup correctly, you'll end up with the binaries uploaded to S3 !
```
