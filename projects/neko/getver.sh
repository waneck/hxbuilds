cd repo/neko
echo "$(git describe --tags $(git rev-list --tags --max-count=1))"
