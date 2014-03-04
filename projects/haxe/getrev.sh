cd repo/haxe
echo "$(git rev-parse --abbrev-ref HEAD)_$(git describe --always)"
