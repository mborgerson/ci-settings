set -ex
source $(dirname $0)/vars.sh

# Push to github
for i in $REPOS; do
    git -C $CHECKOUT_DIR/$i push origin release/$VERSION
    git -C $CHECKOUT_DIR/$i push origin v$VERSION
done
