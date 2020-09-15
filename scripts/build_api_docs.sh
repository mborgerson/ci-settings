set -ex
source $(dirname $0)/vars.sh

pushd "$CHECKOUT_DIR/pyvex"
python setup.py build
popd

make -C "$CHECKOUT_DIR/angr-doc/api-doc" html
rm -rf "$CHECKOUT_DIR/angr.github.io/api-doc"
cp -r "$CHECKOUT_DIR/angr-doc/api-doc/build/html" "$CHECKOUT_DIR/angr.github.io/api-doc"

pushd "$CHECKOUT_DIR/angr.github.io"
git commit --author "angr release bot <angr-dev@asu.edu>" -m "update api-docs for version $VERSION" api-doc
popd
