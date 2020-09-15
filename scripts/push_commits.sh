set -ex

python=python
source "$(dirname "$0")/vars.sh"

# Push to github
for i in $REPOS; do
    if [ "$i" == "angr.github.io" ]; then
        git -C "$CHECKOUT_DIR/$i" push origin master
    else
        git -C "$CHECKOUT_DIR/$i" push origin "release/$VERSION"
        git -C "$CHECKOUT_DIR/$i" push origin "v$VERSION"
    fi
done
